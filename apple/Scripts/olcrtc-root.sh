#!/usr/bin/env bash

require_olcrtc_root() {
  local raw="${1:-${OLCRTC_REPO_ROOT:-}}"
  local usage="${2:-Set OLCRTC_REPO_ROOT=/path/to/olcrtc or pass --olcrtc-root /path/to/olcrtc.}"

  if [[ -z "$raw" ]]; then
    echo "OlcRTC repository path is required." >&2
    echo "$usage" >&2
    echo "Or export OLCRTC_REPO_ROOT=/path/to/olcrtc before running multiple scripts." >&2
    exit 1
  fi

  local resolved
  if [[ "$raw" == /* ]]; then
    resolved="$raw"
  else
    resolved="$(cd "$raw" 2>/dev/null && pwd)" || {
      echo "OlcRTC repository path does not exist: $raw" >&2
      exit 1
    }
  fi

  if [[ ! -f "$resolved/go.mod" || ! -d "$resolved/mobile" || ! -d "$resolved/data" ]]; then
    echo "Invalid OlcRTC repository path: $resolved" >&2
    echo "Expected go.mod, mobile/, and data/ under the provided path." >&2
    exit 1
  fi

  printf '%s\n' "$resolved"
}
