#!/usr/bin/env bash
# Pick a PDF from ~/Books with fzf (text preview) and open it in zathura.
# Usage: dot-books [query]
# Works fullscreen in a plain terminal and inside `tmux display-popup`.

set -o nounset
set -o pipefail

BOOKS_DIR="${BOOKS_DIR:-${HOME}/Books}"

if [ ! -d "${BOOKS_DIR}" ]; then
  echo "dot-books: directory not found: ${BOOKS_DIR}" >&2
  exit 1
fi

# fd is preferred (respects .gitignore, faster); fall back to find.
# Feed fzf as "basename<TAB>full-path" so only the file name is shown
# (subfolders stay searchable), then open the full path.
selected="$(
  {
    if command -v fd >/dev/null 2>&1; then
      fd . "${BOOKS_DIR}" --extension pdf --type f --print0
    else
      find "${BOOKS_DIR}" -type f -iname '*.pdf' -print0
    fi
  } \
    | while IFS= read -r -d '' f; do
      printf '%s\t%s\0' "$(basename "${f}")" "${f}"
    done \
    | sort -z \
    | fzf --read0 --print0 \
      --prompt='books> ' \
      --query="${1:-}" \
      --delimiter '\t' \
      --with-nth 1 \
      --preview 'pdfinfo {2} 2>/dev/null; echo "---"; pdftotext {2} - 2>/dev/null | head -80' \
      --preview-window 'right,60%,wrap' \
    | tr -d '\0'
)"

[ -z "${selected}" ] && exit 0

# strip the displayed basename, keep the full path
selected="${selected#*$'\t'}"

# Detached launch: new session + stdio off the terminal, so the terminal is
# free immediately and zathura survives it being closed. (zathura --fork alone
# keeps the terminal's fds open, which holds the terminal/popup.)
# stderr goes to a log file (not the terminal) so a failed launch leaves a trace.
LOG_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/dot-books.log"
exec setsid -f zathura -- "${selected}" </dev/null >/dev/null 2>"${LOG_FILE}"
