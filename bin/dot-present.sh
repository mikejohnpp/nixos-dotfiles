#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly SOURCE_OUTPUT="${2:-eDP-1}"

cmd="${1:-toggle}"

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$@"
  fi
}

source_enabled() {
  wlr-randr --json |
    jq --raw-output --arg src "${SOURCE_OUTPUT}" \
      'any(.[]; .name == $src and .enabled == true)'
}

find_target() {
  wlr-randr --json |
    jq --raw-output --arg src "${SOURCE_OUTPUT}" \
      '.[] | select(.enabled == true and .name != $src) | .name' |
    head -n1
}

case "${cmd}" in
toggle)
  if pgrep -x wl-mirror >/dev/null 2>&1; then
    pkill -x wl-mirror
    exit 0
  fi

  # An output that is off cannot be captured, so enable the source first.
  if [ "$(source_enabled)" != "true" ]; then
    wlr-randr --output "${SOURCE_OUTPUT}" --on
    sleep 0.5
  fi

  target="$(find_target)"
  if [ -z "${target}" ]; then
    notify "dot-present" "No enabled output other than ${SOURCE_OUTPUT} found."
    exit 0
  fi

  wl-mirror -b screencopy-dmabuf \
    --fullscreen-output "${target}" "${SOURCE_OUTPUT}" &
  ;;
*)
  echo "Usage: dot-present [toggle] [SOURCE_OUTPUT]" >&2
  exit 1
  ;;
esac
