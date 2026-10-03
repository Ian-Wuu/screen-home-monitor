#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
PROJECT_DIR=${SCRIPT_DIR:h}
ROOT_DIR=${PROJECT_DIR:h}
DIST_DIR=${ROOT_DIR}/dist
APP_NAME="AI Screen Stream"
APP_DIR=${DIST_DIR}/${APP_NAME}.app
ZIP_PATH=${DIST_DIR}/AI-Screen-Stream-macOS.zip
CONTENTS_DIR=${APP_DIR}/Contents
MACOS_DIR=${CONTENTS_DIR}/MacOS
RESOURCES_DIR=${CONTENTS_DIR}/Resources
STREAM_URL=rtsp://screen-server.local:8554/ai_workspace
SIGN_IDENTITY=${AI_SIGN_IDENTITY:-}
export CLANG_MODULE_CACHE_PATH=${PROJECT_DIR}/.build/ModuleCache

rm -rf "${APP_DIR}"
rm -f "${ZIP_PATH}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}" "${CLANG_MODULE_CACHE_PATH}"

xcrun swiftc \
  -parse-as-library \
  -O \
  -whole-module-optimization \
  -target arm64-apple-macos13.0 \
  -framework AppKit \
  -framework ScreenCaptureKit \
  -framework CoreMedia \
  -framework CoreVideo \
  -framework SwiftUI \
  -framework ServiceManagement \
  "${PROJECT_DIR}"/Sources/*.swift \
  -o "${MACOS_DIR}/AIScreenStream"

PLIST=${CONTENTS_DIR}/Info.plist
/usr/libexec/PlistBuddy -c 'Clear dict' "${PLIST}" 2>/dev/null || true
/usr/libexec/PlistBuddy -c 'Add :CFBundleDevelopmentRegion string en' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string AI Screen Stream' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleExecutable string AIScreenStream' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string space.easthouse.AIScreenStream' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleInfoDictionaryVersion string 6.0' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleName string AI Screen Stream' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundlePackageType string APPL' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleShortVersionString string 1.0.0' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :CFBundleVersion string 1' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 13.0' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :NSScreenCaptureUsageDescription string AI Screen Stream shares the display you select with your private RTSP server.' "${PLIST}"
/usr/libexec/PlistBuddy -c 'Add :AIStreamURL string' "${PLIST}"
/usr/libexec/PlistBuddy -c "Set :AIStreamURL ${STREAM_URL}" "${PLIST}"

if [[ -x "${PROJECT_DIR}/Vendor/ffmpeg" ]]; then
  cp "${PROJECT_DIR}/Vendor/ffmpeg" "${RESOURCES_DIR}/ffmpeg"
  chmod 755 "${RESOURCES_DIR}/ffmpeg"
  [[ ! -f "${PROJECT_DIR}/Vendor/FFMPEG_LICENSE" ]] || cp "${PROJECT_DIR}/Vendor/FFMPEG_LICENSE" "${RESOURCES_DIR}/FFMPEG_LICENSE"
fi

# File Provider workspaces can synthesize FinderInfo on the app root. It is
# harmless, but codesign rejects it; deleting just that attribute is reliable.
xattr -d com.apple.FinderInfo "${APP_DIR}" 2>/dev/null || true
xattr -d com.apple.ResourceFork "${APP_DIR}" 2>/dev/null || true
if [[ -z "${SIGN_IDENTITY}" ]]; then
  SIGN_IDENTITY=$(security find-identity -v -p codesigning | sed -n 's/.*"\(Apple Development:.*\)"/\1/p' | head -1)
fi
if [[ -n "${SIGN_IDENTITY}" ]]; then
  codesign --force --deep --options runtime --sign "${SIGN_IDENTITY}" "${APP_DIR}"
else
  echo "Warning: no persistent signing identity found; screen recording permission may reset after updates."
  codesign --force --deep --sign - "${APP_DIR}"
fi
ditto -c -k --sequesterRsrc --keepParent "${APP_DIR}" "${ZIP_PATH}"
xattr -d com.apple.FinderInfo "${APP_DIR}" 2>/dev/null || true
xattr -d com.apple.ResourceFork "${APP_DIR}" 2>/dev/null || true
echo "Built ${APP_DIR}"
[[ -x "${RESOURCES_DIR}/ffmpeg" ]] || echo "Warning: ffmpeg was not bundled; app will try /opt/homebrew/bin and /usr/local/bin."
