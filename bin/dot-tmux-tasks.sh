#!/usr/bin/env bash
# Interactive task manager for the tmux status workflow.
# Lists tasks via fzf with a detail preview; single keys run lifecycle
# operations and reload the list. Plain text, no colors.
#
# Subcommands (used by fzf bindings below):
#   dot-tmux-tasks            open the picker
#   dot-tmux-tasks --list     print selectable rows (refreshes the JSON cache)
#   dot-tmux-tasks --preview <id>
#   dot-tmux-tasks --do <op> <id>

set -o pipefail
set -o nounset

# Absolute path: tmux popups may not have ~/.local/bin on PATH.
LET_TIMER_BIN="${LET_TIMER_BIN:-$HOME/.local/bin/let-timer}"
[ -x "${LET_TIMER_BIN}" ] || LET_TIMER_BIN="$(command -v let-timer 2>/dev/null || true)"

CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}/dot-tmux-tasks"
TASKS_JSON="${CACHE_DIR}/tasks.json"

status_icon() {
  case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -d '_-')" in
    inprogress) printf '▶' ;;
    paused) printf '⏸' ;;
    completed) printf '✓' ;;
    cancelled) printf '✗' ;;
    *) printf '○' ;;
  esac
}

cmd_list() {
  if [ -z "${LET_TIMER_BIN}" ]; then
    return 0
  fi
  mkdir -p "${CACHE_DIR}" 2>/dev/null || true
  if "${LET_TIMER_BIN}" tasks list --all-workspaces --json >"${TASKS_JSON}.tmp" 2>/dev/null; then
    mv -f "${TASKS_JSON}.tmp" "${TASKS_JSON}" 2>/dev/null || true
  fi
  [ -f "${TASKS_JSON}" ] || return 0
  jq -r '.OkList[] | "\(.id)\t\(.status)\t\(.name)\t\(.estimated_mins // "-")"' "${TASKS_JSON}" 2>/dev/null |
    while IFS=$'\t' read -r id status name est; do
      printf '%s\t%s %s\t%s\t%s\n' "${id}" "$(status_icon "${status}")" "${status}" "${name}" "${est}"
    done
}

cmd_preview() {
  local id="${1:-}" out
  [ -f "${TASKS_JSON}" ] || { echo "(no data — is the daemon running?)"; return 0; }
  out="$(jq -r --argjson id "${id}" '.OkList[] | select(.id == $id) |
    "Name:        \(.name)",
    "Status:      \(.status)",
    "Workspace:   \(.workspace_id)",
    "Estimate:    \(if .estimated_mins then "\(.estimated_mins) min" else "-" end)",
    "Scheduled:   \(.scheduled_on // "-")",
    "Priority:    \(.priority)",
    (if .description then "Description: \(.description)" else empty end),
    (if .media_list_id then "Media list: \(.media_list_id)" else empty end)' \
    "${TASKS_JSON}" 2>/dev/null)"
  [ -n "${out}" ] || out="(task ${id} not found — list may be stale)"
  printf '%s\n' "${out}"
}

cmd_do() {
  local op="${1:-}" id="${2:-}"
  if [ -z "${LET_TIMER_BIN}" ]; then
    echo "let-timer not found"; return 0
  fi
  case "${op}" in
    start) "${LET_TIMER_BIN}" tasks start --no-interactive --id "${id}" 2>&1 | head -n 3 ;;
    done) "${LET_TIMER_BIN}" tasks done --no-interactive --id "${id}" 2>&1 | head -n 3 ;;
    pause) "${LET_TIMER_BIN}" tasks pause 2>&1 | head -n 3 ;;
    resume) "${LET_TIMER_BIN}" tasks resume 2>&1 | head -n 3 ;;
    stop) "${LET_TIMER_BIN}" tasks stop 2>&1 | head -n 3 ;;
    *) echo "unknown op: ${op}" ;;
  esac
}

task_field() {
  local id="${1:-}" filter="${2:-}"
  jq -r --argjson id "${id}" ".OkList[] | select(.id == \$id) | ${filter}" "${TASKS_JSON}" 2>/dev/null
}

task_name() {
  task_field "${1:-}" '.name'
}

cmd_edit() {
  local id="${1:-}"
  local cur_name cur_est cur_desc
  cur_name="$(task_name "${id}")"
  cur_est="$(task_field "${id}" '.estimated_mins // "-"')"
  cur_desc="$(task_field "${id}" '.description // "-"')"
  local name est desc
  read -r -p "Name [${cur_name}]: " name || return 0
  read -r -p "Estimate mins [${cur_est}, empty = keep, none = clear]: " est || return 0
  read -r -p "Description [${cur_desc}]: " desc || return 0
  local args=(tasks edit --no-interactive --id "${id}")
  [ -n "${name}" ] && args+=(--name "${name}")
  if [ -n "${est}" ]; then
    if [ "${est}" = "none" ]; then args+=(--clear-estimate); else args+=(--estimated-mins "${est}"); fi
  fi
  [ -n "${desc}" ] && args+=(--description "${desc}")
  "${LET_TIMER_BIN}" "${args[@]}" 2>&1 | head -n 5
}

cmd_new() {
  local name est desc ws_id
  read -r -p "Task name: " name || return 0
  [ -n "${name}" ] || { echo "(cancelled — empty name)"; return 0; }
  read -r -p "Estimate mins (empty = none): " est || return 0
  read -r -p "Description (empty = none): " desc || return 0
  ws_id="$("${LET_TIMER_BIN}" workspaces current --json 2>/dev/null | jq -r '.CurrentWorkspace.id // empty')"
  local args=(tasks create --no-interactive -n "${name}" -o today)
  [ -n "${ws_id}" ] && args+=(-w "${ws_id}")
  [ -n "${est}" ] && args+=(-t "${est}")
  [ -n "${desc}" ] && args+=(-d "${desc}")
  "${LET_TIMER_BIN}" "${args[@]}" 2>&1 | head -n 5
}

cmd_delete() {
  local id="${1:-}"
  local label ans
  label="$(task_name "${id}")"
  read -r -p "Delete '${label}'? [y/N] " ans || return 0
  case "${ans}" in
    y|Y|yes|YES) "${LET_TIMER_BIN}" tasks delete --no-interactive --id "${id}" 2>&1 | head -n 3 ;;
    *) echo "(cancelled)" ;;
  esac
}

case "${1:-}" in
  --list) cmd_list ;;
  --preview) cmd_preview "${2:-}" ;;
  --do) cmd_do "${2:-}" "${3:-}" ;;
  --edit) cmd_edit "${2:-}" "${3:-}" ;;
  --new) cmd_new ;;
  --delete) cmd_delete "${2:-}" "${3:-}" ;;
  "")
    if ! command -v fzf >/dev/null 2>&1; then
      echo "fzf not found"; exit 1
    fi
    if ! command -v jq >/dev/null 2>&1; then
      echo "jq not found"; exit 1
    fi
    SELF="$0"
    "${SELF}" --list | fzf \
      --delimiter='\t' \
      --with-nth=2.. \
      --prompt='task> ' \
      --header='enter=start  ^D=done  ^P=pause  ^R=resume  ^S=stop  ^E=edit  ^N=new  ^X=delete' \
      --preview="${SELF} --preview {1}" \
      --preview-window='right:40%:wrap' \
      --bind="enter:execute(${SELF} --do start {1})+reload(${SELF} --list)" \
      --bind="ctrl-d:execute(${SELF} --do done {1})+reload(${SELF} --list)" \
      --bind="ctrl-p:execute(${SELF} --do pause {1})+reload(${SELF} --list)" \
      --bind="ctrl-r:execute(${SELF} --do resume {1})+reload(${SELF} --list)" \
      --bind="ctrl-s:execute(${SELF} --do stop {1})+reload(${SELF} --list)" \
      --bind="ctrl-e:execute(${SELF} --edit {1} </dev/tty)+reload(${SELF} --list)" \
      --bind="ctrl-n:execute(${SELF} --new </dev/tty)+reload(${SELF} --list)" \
      --bind="ctrl-x:execute(${SELF} --delete {1} </dev/tty)+reload(${SELF} --list)"
    ;;
  *) echo "usage: dot-tmux-tasks [--list|--preview ID|--do OP ID|--edit ID|--new|--delete ID]" >&2; exit 1 ;;
esac
