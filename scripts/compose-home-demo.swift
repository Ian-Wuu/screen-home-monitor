// Compose actual, locally captured UI screenshots. No generated or redrawn UI.
// Usage: swift scripts/compose-home-demo.swift HOME_SCREENSHOT CHATGPT_SCREENSHOT
import AppKit

guard CommandLine.arguments.count == 3 else {
    fatalError("Supply local Home and ChatGPT screenshot paths; inspect them for private data first.")
}
func load(_ path: String) -> NSImage {
    let image = NSImage(contentsOfFile: path)!
    let rep = image.representations[0]
    image.size = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    return image
}
func raster(_ w: Int, _ h: Int, _ draw: () -> Void) -> NSImage {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: w, pixelsHigh: h,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    draw()
    NSGraphicsContext.restoreGraphicsState()
    let image = NSImage(size: NSSize(width: w, height: h))
    image.addRepresentation(rep)
    return image
}
func fill(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: NSColor) {
    color.setFill(); NSRect(x: x, y: y, width: w, height: h).fill()
}
func label(_ s: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ color: NSColor) {
    (s as NSString).draw(at: NSPoint(x: x, y: y), withAttributes: [
        .font: NSFont.systemFont(ofSize: size, weight: .medium), .foregroundColor: color])
}
func save(_ image: NSImage, _ name: String) throws {
    let data = (image.representations[0] as! NSBitmapImageRep).representation(using: .png, properties: [:])!
    try data.write(to: URL(fileURLWithPath: "docs/assets/" + name))
}
let home = load(CommandLine.arguments[1])
let gpt = load(CommandLine.arguments[2])
precondition(home.size == NSSize(width: 2048, height: 1284), "Recalibrate crop for this Home screenshot")
precondition(gpt.size == NSSize(width: 2704, height: 1518), "Recalibrate crop for this ChatGPT screenshot")

// Excludes browser tabs/address and the left profile/navigation rail.
let cleanGPT = raster(2596, 1406) {
    gpt.draw(in: NSRect(x: 0, y: 0, width: 2596, height: 1406),
        from: NSRect(x: 108, y: 0, width: 2596, height: 1406), operation: .copy, fraction: 1)
}
try save(cleanGPT, "chatgpt-demo.png")

let composite = raster(2048, 1384) {
    fill(0, 0, 2048, 1384, .white)
    home.draw(in: NSRect(x: 0, y: 100, width: 2048, height: 1284))
    // Remove the OS screen-sharing indicator, not a Home control.
    fill(0, 1278, 186, 106, NSColor(calibratedWhite: 0.063, alpha: 1))
    // The capture was offline. Replace its status with an explicit demo label,
    // never with a claim of live/connected playback.
    fill(270, 1294, 163, 43, NSColor(calibratedWhite: 0.063, alpha: 1))
    label("COMPOSITE", 280, 1307, 19, .lightGray)
    // Replace only the unavailable video region with real ChatGPT pixels.
    cleanGPT.draw(in: NSRect(x: 539, y: 378, width: 1509, height: 849))
    label("Actual macOS Home UI + actual ChatGPT screenshot", 40, 56, 25, .black)
    label("Manually composited demonstration — not a live-stream capture or an iPhone/tvOS screenshot.", 40, 20, 20, .darkGray)
}
try save(composite, "home-chatgpt-demo.png")
print("Saved sanitized ChatGPT screenshot and Home composite")
