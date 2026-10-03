import AppKit
import SwiftUI

#if !SCREENSHOT_BUILD
@main
struct AIScreenStreamApp: App {
    @StateObject private var stream = StreamController()

    var body: some Scene {
        MenuBarExtra("AI Screen Stream", systemImage: stream.status.symbol) {
            StreamMenu(stream: stream)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(stream: stream)
        }
    }
}
#endif

struct StreamMenu: View {
    @ObservedObject var stream: StreamController

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: stream.status.symbol)
                    .foregroundStyle(statusColor)
                Text(stream.status.label).font(.headline)
                Spacer()
            }

            if stream.displays.isEmpty {
                Label("No display connected", systemImage: "display.trianglebadge.exclamationmark")
                    .foregroundStyle(.secondary)
            } else {
                Picker("Display", selection: Binding(
                    get: { stream.selectedDisplayID },
                    set: { id in if let display = stream.displays.first(where: { $0.id == id }) { stream.select(display) } }
                )) {
                    ForEach(stream.displays) { display in
                        Text(display.name).tag(display.id)
                    }
                }
            }

            if stream.status == .permissionRequired {
                Text("Screen Recording access is required.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    Button("Allow Access") { stream.requestPermission() }
                    Button("Open Settings") { stream.openScreenRecordingSettings() }
                }
            } else {
                Button(stream.isActive ? "Stop Streaming" : "Start Streaming") {
                    stream.isActive ? stream.stop() : stream.start()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(stream.selectedDisplay == nil)
            }

            if !stream.lastError.isEmpty, stream.status != .permissionRequired {
                Text(stream.lastError)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .textSelection(.enabled)
            }

            Divider()

            HStack {
                Button("Settings…") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
                Spacer()
                Button("Quit") {
                    stream.stop()
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .padding(16)
        .frame(width: 320)
    }

    private var statusColor: Color {
        switch stream.status {
        case .streaming: return .green
        case .starting: return .blue
        case .connectionFailed, .permissionRequired, .displayDisconnected: return .orange
        case .idle: return .secondary
        }
    }
}

struct SettingsView: View {
    @ObservedObject var stream: StreamController

    var body: some View {
        Form {
            Section("Stream") {
                SecureField("RTSP destination", text: $stream.streamURL)
                    .textFieldStyle(.roundedBorder)
                    .privacySensitive()
                Stepper("Bitrate: \(stream.bitrateKbps / 1_000) Mbps", value: $stream.bitrateKbps, in: 1_000...8_000, step: 500)
                Text("1920 × 1080, 15 fps, H.264 VideoToolbox, TCP")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section("Startup") {
                Toggle("Launch at login", isOn: $stream.launchAtLogin)
                Text("Streaming still starts manually.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
        .frame(width: 460, height: 340)
    }
}
