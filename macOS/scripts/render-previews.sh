#!/bin/zsh
set -euo pipefail
ROOT=${0:A:h:h:h}
mkdir -p "$ROOT/macOS/.build/ModuleCache" "$ROOT/docs/assets"
export CLANG_MODULE_CACHE_PATH="$ROOT/macOS/.build/ModuleCache"
xcrun swiftc -D SCREENSHOT_BUILD -parse-as-library -target arm64-apple-macos13.0 \
  -framework AppKit -framework SwiftUI -framework ServiceManagement \
  -framework ScreenCaptureKit -framework CoreMedia -framework CoreVideo \
  "$ROOT"/macOS/Sources/*.swift "$ROOT/macOS/Tests/RenderPreviews.swift" \
  -o "$ROOT/macOS/.build/render-previews"
"$ROOT/macOS/.build/render-previews" "$ROOT/docs/assets"
