import AppKit
import ApplicationServices
import Foundation
import ServiceManagement

struct Display: Identifiable, Equatable {
    let id: CGDirectDisplayID
    let name: String
    let captureIndex: Int

    static func current() -> [Display] {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &ids, &count)
        return ids.prefix(Int(count)).enumerated().map { index, id in
            let label = NSScreen.screens.first(where: { screenNumber($0) == id })?
                .localizedName ?? "Display \(index + 1)"
            return Display(id: id, name: label, captureIndex: index)
        }
    }

    private static func screenNumber(_ screen: NSScreen) -> CGDirectDisplayID? {
        (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value
    }
}

enum StreamStatus: Equatable {
    case idle
    case starting
    case streaming
    case connectionFailed(String)
    case permissionRequired
    case displayDisconnected

    var label: String {
        switch self {
        case .idle: return "Idle"
        case .starting: return "Connecting…"
        case .streaming: return "Streaming"
        case .connectionFailed: return "Connection Failed"
        case .permissionRequired: return "Permission Required"
        case .displayDisconnected: return "Display Disconnected"
        }
    }

    var symbol: String {
        switch self {
        case .streaming: return "record.circle.fill"
        case .starting: return "arrow.triangle.2.circlepath"
        case .connectionFailed, .permissionRequired, .displayDisconnected: return "exclamationmark.triangle.fill"
        case .idle: return "rectangle.dashed"
        }
    }
}

enum StreamConfig {
    static let fallbackURL = "rtsp://screen-server.local:8554/ai_workspace"

    static var defaultURL: String {
        Bundle.main.object(forInfoDictionaryKey: "AIStreamURL") as? String ?? fallbackURL
    }

    static func arguments(url: String, bitrateKbps: Int) -> [String] {
        let rate = "\(bitrateKbps)k"
        return [
            "-hide_banner", "-nostdin", "-loglevel", "warning",
            "-f", "rawvideo", "-pixel_format", "bgra", "-video_size", "1920x1080", "-framerate", "15", "-i", "pipe:0",
            "-vf", "format=nv12",
            "-an", "-c:v", "h264_videotoolbox", "-realtime", "1",
            "-profile:v", "baseline", "-level", "4.0",
            "-b:v", rate, "-maxrate", rate, "-bufsize", "\(bitrateKbps * 2)k",
            "-g", "15", "-bf", "0",
            "-rw_timeout", "10000000",
            "-rtsp_transport", "tcp", "-f", "rtsp", url
        ]
    }

    static func ffmpegURL(fileManager: FileManager = .default) -> URL? {
        let candidates = [
            Bundle.main.url(forResource: "ffmpeg", withExtension: nil),
            URL(fileURLWithPath: "/opt/homebrew/bin/ffmpeg"),
            URL(fileURLWithPath: "/usr/local/bin/ffmpeg")
        ].compactMap { $0 }
        return candidates.first { fileManager.isExecutableFile(atPath: $0.path) }
    }
}

@MainActor
final class StreamController: ObservableObject {
    @Published private(set) var displays: [Display] = []
    @Published var selectedDisplayID: CGDirectDisplayID
    @Published var streamURL: String {
        didSet { defaults.set(streamURL, forKey: Keys.url) }
    }
    @Published var bitrateKbps: Int {
        didSet { defaults.set(bitrateKbps, forKey: Keys.bitrate) }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            guard !updatingLoginSetting else { return }
            setLaunchAtLogin(launchAtLogin)
        }
    }
    @Published private(set) var status: StreamStatus = .idle
    @Published private(set) var lastError = ""

    private enum Keys {
        static let displayID = "selectedDisplayID"
        static let url = "streamURL"
        static let bitrate = "bitrateKbps"
    }

    private let defaults: UserDefaults
    private var process: Process?
    private var capture: ScreenCapture?
    private var retries = 0
    private var retryTask: Task<Void, Never>?
    private var errorTail = Data()
    private var wantedToStream = false
    private var updatingLoginSetting = false
    private var screenObserver: NSObjectProtocol?
    private var terminationObserver: NSObjectProtocol?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedID = defaults.object(forKey: Keys.displayID) as? NSNumber
        selectedDisplayID = storedID?.uint32Value ?? CGMainDisplayID()
        streamURL = defaults.string(forKey: Keys.url) ?? StreamConfig.defaultURL
        bitrateKbps = defaults.object(forKey: Keys.bitrate) as? Int ?? 3_000
        launchAtLogin = SMAppService.mainApp.status == .enabled
        refreshDisplays()
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.screensChanged() }
        }
        terminationObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.stop() }
        }
    }

    deinit {
        if let screenObserver { NotificationCenter.default.removeObserver(screenObserver) }
        if let terminationObserver { NotificationCenter.default.removeObserver(terminationObserver) }
        retryTask?.cancel()
        terminate(process)
        capture?.stop()
        capture = nil
    }

    var selectedDisplay: Display? { displays.first { $0.id == selectedDisplayID } }
    var isActive: Bool { wantedToStream }

    func select(_ display: Display) {
        let shouldRestart = wantedToStream
        stop(setIdle: !shouldRestart)
        selectedDisplayID = display.id
        defaults.set(Int(display.id), forKey: Keys.displayID)
        if shouldRestart { start() }
    }

    func refreshDisplays() {
        displays = Display.current()
        if selectedDisplay == nil, let first = displays.first, !defaults.contains(key: Keys.displayID) {
            selectedDisplayID = first.id
        }
    }

    func requestPermission() {
        CGRequestScreenCaptureAccess()
        if CGPreflightScreenCaptureAccess() { start() } else { status = .permissionRequired }
    }

    func openScreenRecordingSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
            NSWorkspace.shared.open(url)
        }
    }

    func start() {
        wantedToStream = true
        retryTask?.cancel()
        guard CGPreflightScreenCaptureAccess() else {
            status = .permissionRequired
            if CGRequestScreenCaptureAccess() { start() }
            return
        }
        guard let display = selectedDisplay else {
            status = .displayDisconnected
            return
        }
        guard let executable = StreamConfig.ffmpegURL() else {
            fail("FFmpeg is missing. Rebuild with scripts/build.sh after placing ffmpeg in Vendor/.", retry: false)
            return
        }
        guard let url = URL(string: streamURL), url.scheme == "rtsp", url.host != nil else {
            fail("The RTSP URL is invalid.", retry: false)
            return
        }

        terminate(process)
        lastError = ""
        status = .starting
        let launched = Process()
        launched.executableURL = executable
        launched.arguments = StreamConfig.arguments(url: streamURL, bitrateKbps: bitrateKbps)
        let inputPipe = Pipe()
        launched.standardInput = inputPipe
        let errorPipe = Pipe()
        launched.standardError = errorPipe
        errorTail.removeAll(keepingCapacity: true)
        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty else { return }
            Task { @MainActor in self?.appendErrorOutput(data) }
        }
        launched.terminationHandler = { [weak self, weak launched] process in
            errorPipe.fileHandleForReading.readabilityHandler = nil
            Task { @MainActor in
                let message = String(decoding: self?.errorTail.suffix(1_500) ?? Data(), as: UTF8.self)
                self?.processEnded(launched, status: process.terminationStatus, error: message)
            }
        }
        do {
            try launched.run()
            process = launched
            let capture = ScreenCapture(output: inputPipe.fileHandleForWriting)
            self.capture = capture
            Task { [weak self, weak launched] in
                do {
                    try await capture.start(displayID: display.id)
                } catch {
                    await MainActor.run {
                        guard launched === self?.process else { return }
                        self?.fail(error.localizedDescription, retry: true)
                        self?.terminate(launched)
                    }
                }
            }
            Task { [weak self, weak launched] in
                try? await Task.sleep(for: .seconds(1.2))
                self?.markStreamingIfRunning(launched)
            }
        } catch {
            fail(error.localizedDescription, retry: true)
        }
    }

    func stop(setIdle: Bool = true) {
        wantedToStream = false
        retries = 0
        retryTask?.cancel()
        retryTask = nil
        let running = process
        process = nil
        capture?.stop()
        capture = nil
        terminate(running)
        if setIdle {
            status = .idle
            lastError = ""
        }
    }

    private func markStreamingIfRunning(_ launched: Process?) {
        guard launched === process, launched?.isRunning == true else { return }
        retries = 0
        status = .streaming
    }

    private func appendErrorOutput(_ data: Data) {
        errorTail.append(data)
        if errorTail.count > 8_192 {
            errorTail = Data(errorTail.suffix(8_192))
        }
    }

    private func processEnded(_ ended: Process?, status exitStatus: Int32, error: String) {
        guard ended === process else { return }
        process = nil
        capture?.stop()
        capture = nil
        guard wantedToStream else { return }
        let message = error.trimmed.isEmpty ? "FFmpeg exited with status \(exitStatus)." : error.trimmed
        fail(message, retry: true)
    }

    private func fail(_ message: String, retry: Bool) {
        let safeMessage = message.replacingOccurrences(of: streamURL, with: "rtsp://***@destination")
        lastError = safeMessage
        status = .connectionFailed(safeMessage)
        guard retry, wantedToStream, retries < 4 else { return }
        let delay = min(pow(2.0, Double(retries)), 8.0)
        retries += 1
        retryTask?.cancel()
        retryTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(delay))
            guard !Task.isCancelled else { return }
            self?.start()
        }
    }

    private func screensChanged() {
        let wasStreaming = wantedToStream
        let oldCaptureIndex = selectedDisplay?.captureIndex
        refreshDisplays()
        if selectedDisplay == nil {
            stop(setIdle: false)
            status = .displayDisconnected
            wantedToStream = wasStreaming
        } else if wasStreaming, status == .displayDisconnected {
            start()
        } else if wasStreaming, oldCaptureIndex != selectedDisplay?.captureIndex {
            stop(setIdle: false)
            start()
        }
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            enabled ? try SMAppService.mainApp.register() : try SMAppService.mainApp.unregister()
        } catch {
            updatingLoginSetting = true
            launchAtLogin = SMAppService.mainApp.status == .enabled
            updatingLoginSetting = false
            lastError = "Launch at login: \(error.localizedDescription)"
        }
    }

    nonisolated private func terminate(_ process: Process?) {
        guard let process, process.isRunning else { return }
        process.terminate()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if process.isRunning { kill(process.processIdentifier, SIGKILL) }
        }
    }
}

private extension UserDefaults {
    func contains(key: String) -> Bool { object(forKey: key) != nil }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
