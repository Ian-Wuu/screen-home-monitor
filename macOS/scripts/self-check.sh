#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
PROJECT_DIR=${SCRIPT_DIR:h}
BUILD_DIR=${PROJECT_DIR}/.build
mkdir -p "${BUILD_DIR}"
export CLANG_MODULE_CACHE_PATH=${BUILD_DIR}/ModuleCache
mkdir -p "${CLANG_MODULE_CACHE_PATH}"

xcrun swiftc \
  -parse-as-library \
  -O \
  -target arm64-apple-macos13.0 \
  -framework AppKit \
  -framework ServiceManagement \
  -framework ScreenCaptureKit \
  -framework CoreMedia \
  -framework CoreVideo \
  "${PROJECT_DIR}/Sources/StreamCore.swift" \
  "${PROJECT_DIR}/Sources/ScreenCapture.swift" \
  "${PROJECT_DIR}/Tests/SelfCheck.swift" \
  -o "${BUILD_DIR}/self-check"
"${BUILD_DIR}/self-check"
