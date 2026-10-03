import Foundation

@main
struct SelfCheck {
    static func main() {
        let args = StreamConfig.arguments(
            url: "rtsp://example.local:8554/test",
            bitrateKbps: 3_000
        )
        precondition(args.contains("rawvideo"))
        precondition(args.contains("pipe:0"))
        precondition(args.contains("h264_videotoolbox"))
        precondition(args.contains("baseline"))
        precondition(args.contains("4.0"))
        precondition(args.contains("3000k"))
        precondition(args.suffix(2) == ["rtsp", "rtsp://example.local:8554/test"])
        precondition(StreamConfig.fallbackURL == "rtsp://screen-server.local:8554/ai_workspace")
        print("macOS self-check passed")
    }
}
