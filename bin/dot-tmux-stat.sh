#!/usr/bin/env bash
# Print a single system metric for the tmux status bar. Values are plain text
# only, tmux keeps the styling. Supported modes: cpu-temp, cpu, temp, mem,
# weather, all.

set -o pipefail
set -o nounset

MODE="${1:-all}"

CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dot-tmux-stat"
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/dot-tmux-stat"
readonly WEATHER_TTL=900
readonly WEATHER_URL='https://wttr.in/?format=%25c+%25t&m'

# CPU busy percentage since the previous call. The first call has no sample to
# compare against, so it falls back to the average since boot.
cpu_usage() {
  local sample total idle usage prev_total prev_idle

  sample="$(awk '/^cpu /{print $2 + $3 + $4 + $5 + $6 + $7 + $8, $5 + $6; exit}' /proc/stat)"
  read -r total idle <<<"${sample}"

  usage=""
  if [ -r "${STATE_DIR}/cpu" ]; then
    read -r prev_total prev_idle <"${STATE_DIR}/cpu"
    if [ "$((total - prev_total))" -gt 0 ]; then
      usage="$(((total - prev_total - (idle - prev_idle)) * 100 / (total - prev_total)))"
    fi
  fi
  if [ -z "${usage}" ] && [ "${total}" -gt 0 ]; then
    usage="$(((total - idle) * 100 / total))"
  fi

  mkdir -p "${STATE_DIR}" 2>/dev/null || true
  printf '%s %s\n' "${total}" "${idle}" >"${STATE_DIR}/cpu.tmp" 2>/dev/null &&
    mv -f "${STATE_DIR}/cpu.tmp" "${STATE_DIR}/cpu" 2>/dev/null

  [ "${usage}" -ge 0 ] 2>/dev/null || usage=0
  printf '%s%%\n' "${usage}"
}

# Package temperature, coretemp first, then any CPU thermal zone.
temp_celsius() {
  local hwmon zone value

  for hwmon in /sys/class/hwmon/hwmon*; do
    [ -r "${hwmon}/name" ] || continue
    if [ "$(<"${hwmon}/name")" = coretemp ] && [ -r "${hwmon}/temp1_input" ]; then
      value="$(<"${hwmon}/temp1_input")"
      printf '%d°C\n' "$((value / 1000))"
      return 0
    fi
  done

  for zone in /sys/class/thermal/thermal_zone*; do
    [ -r "${zone}/type" ] || continue
    case "$(<"${zone}/type")" in
    x86_pkg_temp | cpu | TCPU | SEN3)
      value="$(<"${zone}/temp")"
      printf '%d°C\n' "$((value / 1000))"
      return 0
      ;;
    esac
  done
}

# Memory in use, MemTotal - MemAvailable so cache counts as used.
mem_usage() {
  awk '/^MemTotal:/ {total = $2}
       /^MemAvailable:/ {available = $2}
       END {if (total > 0) printf "%d%%\n", (total - available) * 100 / total}' \
    /proc/meminfo
}

# wttr.in, read from cache so a status redraw never waits on the network. A
# stale or missing cache is refilled in the background and keeps the last good
# value if the request fails.
weather_now() {
  local file="${CACHE_DIR}/weather.txt" now age output

  printf -v now '%(%s)T' -1
  age="$((now - $(stat -c %Y "${file}" 2>/dev/null || printf '%s' "${now}")))"
  if command -v curl >/dev/null 2>&1 && { [ ! -s "${file}" ] || [ "${age}" -ge "${WEATHER_TTL}" ]; }; then
    mkdir -p "${CACHE_DIR}" 2>/dev/null || true
    (
      umask 077
      if curl -fsS --max-time 5 "${WEATHER_URL}" >"${file}.tmp" 2>/dev/null; then
        mv -f "${file}.tmp" "${file}"
      else
        rm -f "${file}.tmp"
      fi
    ) >/dev/null 2>&1 &
  fi

  if [ ! -s "${file}" ]; then
    printf -- '-\n'
    return 0
  fi
  output="$(<"${file}")"
  printf '%s\n' "${output//  / }"
}

cpu_and_temp() {
  local parts=()

  [ -n "${SHOW_CPU}" ] && parts+=("$(cpu_usage)")
  [ -n "${SHOW_TEMP}" ] && parts+=("$(temp_celsius)")

  printf '%s\n' "${parts[*]-}"
}

case "${MODE}" in
cpu-temp)
  SHOW_CPU=1 SHOW_TEMP=1
  cpu_and_temp
  ;;
cpu)
  cpu_usage
  ;;
temp)
  temp_celsius
  ;;
mem)
  mem_usage
  ;;
weather)
  weather_now
  ;;
all)
  printf 'cpu-temp: %s\n' "$(SHOW_CPU=1 SHOW_TEMP=1 cpu_and_temp)"
  printf 'mem: %s\n' "$(mem_usage)"
  printf 'weather: %s\n' "$(weather_now)"
  ;;
*)
  echo "'${MODE}' is not a supported, aborting!" >&2
  exit 1
  ;;
esac
