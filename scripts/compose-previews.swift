// Deterministic documentation composites. No image-generation model is used.
// Run from the repository root: swift scripts/compose-previews.swift
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let out = root.appendingPathComponent("docs/assets")
let ink = NSColor(calibratedWhite: 0.10, alpha: 1)
let muted = NSColor(calibratedWhite: 0.43, alpha: 1)
let paper = NSColor(calibratedRed: 0.97, green: 0.97, blue: 0.95, alpha: 1)

func box(_ r: NSRect, _ color: NSColor, _ radius: CGFloat = 0) {
    color.setFill()
    NSBezierPath(roundedRect: r, xRadius: radius, yRadius: radius).fill()
}
func text(_ s: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat,
          _ color: NSColor = ink, mono: Bool = false, bold: Bool = false) {
    let font = mono ? NSFont.monospacedSystemFont(ofSize: size, weight: bold ? .semibold : .regular)
                    : NSFont.systemFont(ofSize: size, weight: bold ? .semibold : .regular)
    (s as NSString).draw(at: NSPoint(x: x, y: y), withAttributes: [.font: font, .foregroundColor: color])
}
func raster(_ width: Int, _ height: Int, _ draw: () -> Void) -> NSImage {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    draw()
    NSGraphicsContext.restoreGraphicsState()
    let image = NSImage(size: NSSize(width: width, height: height))
    image.addRepresentation(bitmap)
    return image
}
func save(_ image: NSImage, _ name: String) throws {
    let data = (image.representations[0] as! NSBitmapImageRep).representation(using: .png, properties: [:])!
    try data.write(to: out.appendingPathComponent(name))
}

// Native text rendering of actual public source and recorded local test output.
// This is sample screen content, not a capture of a running Home video session.
let source = try String(contentsOf: root.appendingPathComponent("macOS/Tests/SelfCheck.swift"), encoding: .utf8)
let sample = raster(1280, 720) {
    box(NSRect(x: 0, y: 0, width: 1280, height: 720), NSColor(calibratedWhite: 0.96, alpha: 1))
    box(NSRect(x: 0, y: 675, width: 1280, height: 45), NSColor.white)
    for (x, c) in [(CGFloat(20), NSColor.systemRed), (CGFloat(42), NSColor.systemYellow), (CGFloat(64), NSColor.systemGreen)] {
        box(NSRect(x: x, y: 690, width: 12, height: 12), c, 6)
    }
    text("screen-home-monitor  /  SelfCheck.swift", 100, 688, 18, muted)
    text("PUBLIC SOURCE", 32, 626, 13, muted, bold: true)
    let lines = source.components(separatedBy: "\n").flatMap { line -> [String] in
        var rest = line
        var wrapped: [String] = []
        while rest.count > 86 {
            wrapped.append(String(rest.prefix(86)))
            rest = "    " + String(rest.dropFirst(86))
        }
        return wrapped + [rest]
    }
    for (i, line) in lines.prefix(25).enumerated() {
        text(String(format: "%02d", i + 1), 32, 589 - CGFloat(i) * 22, 14, muted, mono: true)
        text(line, 76, 589 - CGFloat(i) * 22, 14, ink, mono: true)
    }
    box(NSRect(x: 880, y: 32, width: 368, height: 607), NSColor.white, 12)
    text("LOCAL CHECKS", 908, 594, 13, muted, bold: true)
    text("$ self-check.sh", 908, 542, 16, muted, mono: true)
    text("macOS self-check passed", 908, 508, 17, ink, mono: true)
    text("$ self-check.py", 908, 439, 16, muted, mono: true)
    text("Server configuration", 908, 405, 17, ink, mono: true)
    text("self-check passed", 908, 379, 17, ink, mono: true)
    text("VIEW ONLY", 908, 148, 13, muted, bold: true)
    text("No remote clicks.", 908, 113, 17, muted)
    text("No task detection.", 908, 85, 17, muted)
}
try save(sample, "demo-screen.png")

let tv = raster(1600, 1050) {
    box(NSRect(x: 0, y: 0, width: 1600, height: 1050), paper)
    text("SCREEN HOME MONITOR", 100, 964, 18, muted, bold: true)
    text("A glance from the sofa.", 100, 904, 38, ink, bold: true)
    box(NSRect(x: 100, y: 130, width: 1400, height: 728), ink, 20)
    sample.draw(in: NSRect(x: 114, y: 144, width: 1372, height: 700))
    box(NSRect(x: 1240, y: 774, width: 224, height: 48), NSColor(calibratedWhite: 0.1, alpha: 0.88), 24)
    text("‹   Workspace", 1265, 787, 21, .white, bold: true)
    box(NSRect(x: 724, y: 104, width: 152, height: 26), ink, 3)
    box(NSRect(x: 650, y: 92, width: 300, height: 12), ink, 6)
    text("Hand-composited demo · Sample content, not a tvOS screenshot", 100, 38, 18, muted)
}
try save(tv, "demo-tv.png")

let phone = raster(1000, 1200) {
    box(NSRect(x: 0, y: 0, width: 1000, height: 1200), paper)
    text("SCREEN HOME MONITOR", 80, 1118, 18, muted, bold: true)
    text("Your workspace, at hand.", 80, 1055, 36, ink, bold: true)
    box(NSRect(x: 263, y: 152, width: 474, height: 851), ink, 60)
    box(NSRect(x: 275, y: 164, width: 450, height: 827), .white, 49)
    box(NSRect(x: 427, y: 949, width: 146, height: 28), ink, 14)
    text("9:41", 311, 949, 17, ink, bold: true)
    text("Home", 305, 868, 37, ink, bold: true)
    text("+", 665, 872, 34, muted)
    text("Cameras", 306, 813, 22, ink, bold: true)
    box(NSRect(x: 298, y: 493, width: 404, height: 293), NSColor(calibratedWhite: 0.96, alpha: 1), 18)
    sample.draw(in: NSRect(x: 298, y: 555, width: 404, height: 227))
    text("Workspace", 315, 514, 22, ink, bold: true)
    text("›", 668, 510, 28, muted)
    text("The same Mac screen.", 315, 422, 21, ink)
    text("Open the camera to look.", 315, 385, 18, muted)
    text("Return to your Mac to act.", 315, 353, 18, muted)
    box(NSRect(x: 421, y: 183, width: 158, height: 5), ink, 2.5)
    text("Hand-composited demo · Simplified Home-style layout", 80, 84, 18, muted)
    text("Sample content — not an iPhone screenshot or playback test", 80, 53, 16, muted)
}
try save(phone, "demo-phone.png")
print("Saved demo-screen.png, demo-tv.png and demo-phone.png")
