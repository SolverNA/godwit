#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APPLE_DIR="$ROOT_DIR/apple"
OUT_DIR="$APPLE_DIR/Frameworks"
OUT="$OUT_DIR/Mobile.xcframework"

usage() {
  cat <<'MSG'
Usage:
  ./apple/Scripts/build-xcframework.sh --olcrtc-root /path/to/olcrtc

The OlcRTC repository path can also be provided with OLCRTC_REPO_ROOT.
MSG
}

OLCRTC_ROOT_ARG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --olcrtc-root)
      OLCRTC_ROOT_ARG="${2:-}"
      if [[ -z "$OLCRTC_ROOT_ARG" ]]; then
        echo "--olcrtc-root requires a path" >&2
        exit 1
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

source "$APPLE_DIR/Scripts/olcrtc-root.sh"
OLCRTC_DIR="$(require_olcrtc_root "$OLCRTC_ROOT_ARG" "Usage: ./apple/Scripts/build-xcframework.sh --olcrtc-root /path/to/olcrtc")"

if [[ -z "${DEVELOPER_DIR:-}" && -d /Applications/Xcode.app/Contents/Developer ]]; then
  export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
fi

command -v gomobile >/dev/null 2>&1 || {
  echo "gomobile not found. Install it with:"
  echo "  go install golang.org/x/mobile/cmd/gomobile@latest"
  echo "  gomobile init"
  exit 1
}

if ! xcrun --sdk iphoneos --show-sdk-path >/dev/null 2>&1; then
  cat <<'MSG'
Xcode iOS SDK is not ready.

If Xcode is installed, finish the first-run setup from Terminal:
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -license accept

Then rerun this script.
MSG
  exit 1
fi

mkdir -p "$OUT_DIR"
rm -rf "$OUT"

cd "$OLCRTC_DIR"

gomobile bind \
  -target=ios,iossimulator,macos \
  -ldflags="-s -w -checklinkname=0" \
  -o "$OUT" \
  ./mobile

echo "Built $OUT"
