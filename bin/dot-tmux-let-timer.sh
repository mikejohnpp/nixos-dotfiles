#!/usr/bin/env bash
# Print the currently running let-timer task for the tmux status bar.
# Output is the `tasks current --format short` line (e.g. "⏳ 15:32 Read chapter 3")
# or nothing when idle/unreachable. Plain text only, tmux keeps the styling.
# Never fails and never blocks: 1s timeout plus a short on-disk cache so a
# slow/remote daemon cannot stall the status bar redraw.

set -o pipefail
set -o nounset

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/dot-tmux-let-timer"
CACHE="${STATE_DIR}/cache"
readonly TTL=4
readonly MAX_CHARS=40

now="$(date +%s)"
if [ -f "${CACHE}" ]; then
  mtime="$(stat -c %Y "${CACHE}" 2>/dev/null || echo 0)"
  if [ "$((now - mtime))" -lt "${TTL}" ]; then
    cat "${CACHE}" 2>/dev/null || true
    exit 0
  fi
fi

# Absolute path: tmux #() commands run with the tmux *server* environment
# (frozen at server start), which may predate ~/.local/bin on PATH.
LET_TIMER_BIN="${LET_TIMER_BIN:-$HOME/.local/bin/let-timer}"
[ -x "${LET_TIMER_BIN}" ] || LET_TIMER_BIN="$(command -v let-timer 2>/dev/null || true)"

out=""
if [ -n "${LET_TIMER_BIN}" ]; then
  out="$(timeout 1 "${LET_TIMER_BIN}" tasks current --format short 2>/dev/null | cut -c1-${MAX_CHARS})" || out=""
fi

mkdir -p "${STATE_DIR}" 2>/dev/null || true
printf '%s' "${out}" >"${CACHE}.tmp" 2>/dev/null &&
  mv -f "${CACHE}.tmp" "${CACHE}" 2>/dev/null || true
printf '%s' "${out}"
exit 0
