import CoreMedia
import CoreVideo
import Foundation
import ScreenCaptureKit

final class ScreenCapture: NSObject, SCStreamOutput {
    private var stream: SCStream?
    private let output: FileHandle
    private let queue = DispatchQueue(label: "space.easthouse.AIScreenStream.capture")
    private let outputQueue = DispatchQueue(label: "space.easthouse.AIScreenStream.output")
    private let frameLock = NSLock()
    private var latestFrame: Data?
    private var outputTimer: DispatchSourceTimer?

    init(output: FileHandle) {
        self.output = output
    }

    func start(displayID: CGDirectDisplayID) async throws {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        guard let display = content.displays.first(where: { $0.displayID == displayID }) else {
            throw CaptureError.displayMissing
        }
        let filter = SCContentFilter(display: display, excludingWindows: [])
        let configuration = SCStreamConfiguration()
        configuration.width = 1920
        configuration.height = 1080
        configuration.minimumFrameInterval = CMTime(value: 1, timescale: 15)
        configuration.pixelFormat = kCVPixelFormatType_32BGRA
        configuration.queueDepth = 3
        configuration.showsCursor = true
        configuration.capturesAudio = false

        let stream = SCStream(filter: filter, configuration: configuration, delegate: nil)
        try stream.addStreamOutput(self, type: .screen, sampleHandlerQueue: queue)
        self.stream = stream
        try await stream.startCapture()
        startOutputTimer()
    }

    func stop() {
        outputTimer?.cancel()
        outputTimer = nil
        guard let stream else { return }
        self.stream = nil
        Task { try? await stream.stopCapture() }
        try? output.close()
    }

    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen, sampleBuffer.isValid,
              let image = sampleBuffer.imageBuffer else { return }
        CVPixelBufferLockBaseAddress(image, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(image, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(image) else { return }
        let widthBytes = CVPixelBufferGetWidth(image) * 4
        let height = CVPixelBufferGetHeight(image)
        let rowBytes = CVPixelBufferGetBytesPerRow(image)
        let frame: Data
        if rowBytes == widthBytes {
            frame = Data(bytes: base, count: widthBytes * height)
        } else {
            var packed = Data(count: widthBytes * height)
            packed.withUnsafeMutableBytes { destination in
                guard let destinationBase = destination.baseAddress else { return }
                for row in 0..<height {
                    memcpy(destinationBase.advanced(by: row * widthBytes), base.advanced(by: row * rowBytes), widthBytes)
                }
            }
            frame = packed
        }
        frameLock.withLock { latestFrame = frame }
    }

    private func startOutputTimer() {
        let timer = DispatchSource.makeTimerSource(queue: outputQueue)
        timer.schedule(deadline: .now(), repeating: 1.0 / 15.0, leeway: .milliseconds(2))
        timer.setEventHandler { [weak self] in
            guard let self, let frame = self.frameLock.withLock({ self.latestFrame }) else { return }
            self.output.write(frame)
        }
        outputTimer = timer
        timer.resume()
    }

    enum CaptureError: LocalizedError {
        case displayMissing
        var errorDescription: String? { "The selected display is no longer available." }
    }
}
