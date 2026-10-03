import AppKit
import SwiftUI

// Render the real SwiftUI views without starting capture or reading user settings.
@main
struct RenderPreviews {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.appearance = NSAppearance(named: .aqua)
        let defaults = UserDefaults(suiteName: "AIScreenStream.DocumentationPreview")!
        defaults.removePersistentDomain(forName: "AIScreenStream.DocumentationPreview")
        defaults.set("rtsp://screen-server.local:8554/ai_workspace", forKey: "streamURL")
        defer { defaults.removePersistentDomain(forName: "AIScreenStream.DocumentationPreview") }
        let controller = StreamController(defaults: defaults)
        let destination = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        try render(StreamMenu(stream: controller), size: NSSize(width: 320, height: 240),
                   to: destination.appendingPathComponent("menu.png"))
        try render(SettingsView(stream: controller), size: NSSize(width: 492, height: 390),
                   to: destination.appendingPathComponent("settings.png"))
    }

    @MainActor static func render<V: View>(_ view: V, size: NSSize, to url: URL) throws {
        let host = NSHostingView(rootView: view.environment(\.colorScheme, .light).background(Color.white))
        host.frame = NSRect(origin: .zero, size: size)
        host.layoutSubtreeIfNeeded()
        guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width * 2),
            pixelsHigh: Int(size.height * 2), bitsPerSample: 8, samplesPerPixel: 4,
            hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            throw NSError(domain: "PreviewRender", code: 1)
        }
        bitmap.size = size
        host.cacheDisplay(in: host.bounds, to: bitmap)
        guard let png = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "PreviewRender", code: 2)
        }
        try png.write(to: url)
    }
}
