#!/usr/bin/env bash
#
# setup-fedora.sh — bootstrap a fresh Fedora machine to match the
# fedora-btw profile (labwc + noctalia system-side, Home Manager for CLI).
#
# Usage:
#   setup-fedora.sh [-a] [--initial] [--nix] [--system] [--dm] [--hm] [--config]
#                   [--shell] [--force-software|--force-gpu] [--repo PATH]
#
# Phases (default runs --initial --nix --system --hm --config):
#   --initial  base groups, GNOME base apps, graphical boot, RPM Fusion,
#              COPR repos (ghostty, fcitx5-bamboo),
#              Intel media driver (only when an Intel GPU is present)
#   --nix      install Nix (dnf: package nix + nix-daemon) if missing, copy nix.conf
#   --system   dnf-install GUI system packages, WirePlumber combined
#              analog+HDMI sinks (monitor speakers + built-in analog),
#              clean stale session file
#   --hm       build + switch home-manager configuration "fedora-btw"
#              from the flake (uses the flake's own pinned home-manager)
#   --config   write labwc/environment (GPU-detected); ensure xterm-ghostty terminfo;
#              rest of config is HM-owned
#   --dm       greetd + tuigreet TUI display manager (replaces GDM)
#   --shell    opt-in: zsh login wrapper (/usr/local/bin/zzsh) + chsh
#
# Optional extra flags (run alongside the phases above):
#   --docker   Docker CE + compose plugin (mirrors desk custom.nix)
#   --virt     libvirt + qemu group (@virtualization)
#   --laptop   thermald + fwupd (laptop power/firmware)
#   --zram     systemd-zram-generator (swap on zram)
#
# Idempotent: safe to re-run. REPO auto-detected via $SETUP_REPO, then
# /mnt/shared (VM virtiofs), then this repo checkout.

set -o errexit
set -o pipefail
set -o nounset

DO_INITIAL=0
DO_NIX=0
DO_SYSTEM=0
DO_HM=0
DO_CONFIG=0
DO_DM=0
DO_SHELL=0
DO_DOCKER=0
DO_VIRT=0
DO_LAPTOP=0
DO_ZRAM=0
FORCE_SOFTWARE=""
REPO="${SETUP_REPO:-}"
MAIN_SELECTED=0

usage() {
  sed -n '2,29p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' >&2
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    -a | --all) DO_INITIAL=1 DO_NIX=1 DO_SYSTEM=1 DO_HM=1 DO_CONFIG=1 MAIN_SELECTED=1 ;;
    -i | --initial) DO_INITIAL=1 MAIN_SELECTED=1 ;;
    -n | --nix) DO_NIX=1 MAIN_SELECTED=1 ;;
    -s | --system) DO_SYSTEM=1 MAIN_SELECTED=1 ;;
    -h | --hm) DO_HM=1 MAIN_SELECTED=1 ;;
    -c | --config) DO_CONFIG=1 MAIN_SELECTED=1 ;;
    --dm) DO_DM=1 MAIN_SELECTED=1 ;;
    --shell) DO_SHELL=1 ;;
    --docker) DO_DOCKER=1 ;;
    --virt) DO_VIRT=1 ;;
    --laptop) DO_LAPTOP=1 ;;
    --zram) DO_ZRAM=1 ;;
    --force-software) FORCE_SOFTWARE=1 ;;
    --force-gpu) FORCE_SOFTWARE=0 ;;
    -r | --repo) shift; REPO="$1" ;;
    --help | -help | help) usage ;;
    *) echo "setup-fedora.sh: unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

if [ "$MAIN_SELECTED" = 0 ]; then
  DO_INITIAL=1 DO_NIX=1 DO_SYSTEM=1 DO_HM=1 DO_CONFIG=1
fi

if [ "$(id -u)" = 0 ]; then
  echo "error: run as a normal user (sudo is requested internally)" >&2
  exit 1
fi

resolve_repo() {
  if [ -n "$REPO" ] && [ -f "$REPO/flake.nix" ]; then
    printf '%s\n' "$REPO"
    return 0
  fi
  if [ -f /mnt/shared/flake.nix ]; then
    printf '%s\n' /mnt/shared
    return 0
  fi
  local self
  self="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "$self/../flake.nix" ]; then
    printf '%s\n' "$(cd "$self/.." && pwd)"
    return 0
  fi
  return 1
}

if ! REPO="$(resolve_repo)"; then
  echo "error: cannot locate the dotfiles repo.
Clone it first (e.g. git clone <url> ~/nixos-dotfiles), then run this
script again, or pass --repo PATH / SETUP_REPO." >&2
  exit 1
fi
echo "> repo: $REPO"

need_sudo() {
  if ! sudo -n true 2>/dev/null; then
    echo "> sudo access required (enter password when prompted)"
    sudo -v
  fi
}

if [ "$DO_INITIAL" = 1 ]; then
  need_sudo
  echo "> initial: base groups, GNOME base apps, graphical boot, RPM Fusion"
  sudo dnf install -y @hardware-support @multimedia NetworkManager-wifi
  sudo dnf install -y gnome-shell adw-gtk3-theme ptyxis nautilus flatpak \
    gnome-software gvfs-mtp
  sudo systemctl set-default graphical.target
  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
  sudo dnf copr enable -y scottames/ghostty
  sudo dnf copr enable -y vuongtuha/fcitx5-bamboo
  if command -v lspci >/dev/null 2>&1 && lspci | grep -qi 'vga.*intel'; then
    sudo dnf install -y intel-media-driver
  else
    echo "> skipped intel-media-driver (no Intel GPU detected)"
  fi
fi

if [ "$DO_NIX" = 1 ]; then
  if command -v nix >/dev/null 2>&1; then
    echo "> nix: already installed"
  else
    need_sudo
    if sudo dnf install -y nix nix-daemon >/dev/null 2>&1; then
      sudo systemctl enable --now nix-daemon
      echo "> nix installed (Fedora package, daemon mode; socket-activated)"
    else
      echo "> nix not in the Fedora repo (Fedora <44?), falling back to Determinate installer"
      curl -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
      export PATH="$PATH:/nix/var/nix/profiles/default/bin"
    fi
  fi
  mkdir -p "$HOME/.config/nix"
  cp -f "$REPO/nix.conf" "$HOME/.config/nix/nix.conf"
  echo "> nix.conf copied (user-level; merges with /etc/nix/nix.conf)"
fi

if [ "$DO_SYSTEM" = 1 ]; then
  need_sudo
  echo "> dnf: installing system GUI packages"
  sudo dnf install -y labwc labwc-session noctalia \
    ghostty dolphin fcitx5 fcitx5-unikey fcitx5-bamboo kanshi wlr-randr \
    pipewire-pulseaudio wireplumber pavucontrol \
    upower udisks2 gvfs tumbler xdg-desktop-portal-gtk \
    openssh-server fuse bluez blueman firefox breeze-cursor-theme \
    libva-utils gcc make tree lsof wget xdg-utils mpv
  sudo systemctl enable --now sshd bluetooth
  if [ -f /usr/share/wayland-sessions/labwc.desktop ] &&
    ! rpm -q -f /usr/share/wayland-sessions/labwc.desktop >/dev/null 2>&1; then
    sudo rm -f /usr/share/wayland-sessions/labwc.desktop
    echo "> removed stray /usr/share/wayland-sessions/labwc.desktop"
  fi

  # WirePlumber: combined ACP profile-set ("multiple") so built-in analog
  # and HDMI/DP (monitor speakers) sinks coexist on the same card and stay
  # selectable (wpctl default sink / pavucontrol; pwvucontrol comes via
  # Flatpak since it is not packaged in Fedora). User-level overrides
  # (~/.config) are documented for both wireplumber.conf.d and
  # alsa-card-profile, so no sudo is needed for these files.
  alsa_card="$(pactl list cards short 2>/dev/null | awk 'NR == 1 { print $2; exit }')"
  [ -n "$alsa_card" ] || alsa_card='alsa_card_*'

  acp_dir="$HOME/.config/alsa-card-profile/mixer/profile-sets"
  acp_conf="$acp_dir/multiple.conf"
  mkdir -p "$acp_dir"
  if [ ! -f "$acp_conf" ]; then
    tee "$acp_conf" >/dev/null <<'MULTCONF'
[General]
auto-profiles = no

[Mapping analog-stereo]
description = Analog Stereo
device-strings = front:%f
channel-map = left,right
paths-output = analog-output analog-output-lineout analog-output-speaker analog-output-headphones
paths-input = analog-input-front-mic analog-input-rear-mic analog-input-internal-mic analog-input
priority = 15

[Mapping hdmi-stereo]
description = Digital Stereo (HDMI)
device-strings = hdmi:%f
paths-output = hdmi-output-0
channel-map = left,right
priority = 9
direction = output

[Profile multiple]
description = Analog Stereo Duplex + Digital Stereo (HDMI) Output
output-mappings = analog-stereo hdmi-stereo
input-mappings = analog-stereo
MULTCONF
    echo "> wrote $acp_conf (combined analog+HDMI ACP profile-set)"
  fi

  wp_dir="$HOME/.config/wireplumber/wireplumber.conf.d"
  wp_conf="$wp_dir/61-alsa-multiple.conf"
  mkdir -p "$wp_dir"
  if [ ! -f "$wp_conf" ]; then
    tee "$wp_conf" >/dev/null <<WPCONF
monitor.alsa.rules = [
  {
    matches = [ { device.name = "$alsa_card" } ]
    actions = {
      update-props = {
        api.alsa.use-acp = true
        api.acp.auto-profile = false
        api.acp.auto-port = false
        device.profile-set = "multiple.conf"
        device.profile = "multiple"
      }
    }
  }
]
WPCONF
    echo "> wrote $wp_conf (force profile-set multiple.conf; matched card: $alsa_card)"
  fi

  # Remove the old (invalid) profile-disable drop-in from an earlier attempt:
  # `api.alsa.card.profile` is not a real PipeWire property and the rule used
  # node.name on the card device, which never exists.
  if [ -f /etc/wireplumber/wireplumber.conf.d/51-disable-card-profiles.conf ]; then
    sudo rm -f /etc/wireplumber/wireplumber.conf.d/51-disable-card-profiles.conf
    echo "> removed stale /etc/wireplumber/wireplumber.conf.d/51-disable-card-profiles.conf"
  fi
  systemctl --user restart pipewire pipewire-pulse wireplumber 2>/dev/null || true
fi

if [ "$DO_DM" = 1 ]; then
  need_sudo
  echo "> dm: installing greetd + tuigreet (TUI login, replaces GDM)"
  sudo dnf install -y greetd greetd-selinux tuigreet

  # greetd runs the greeter as a dedicated account; its home points at
  # /var/lib/greetd (the greetd package's tmpfiles create it, owned
  # greetd:greetd).
  if ! id greeter >/dev/null 2>&1; then
    sudo useradd -r -M -s /sbin/nologin -d /var/lib/greetd -G video,greetd greeter
  else
    sudo usermod -aG video,greetd greeter
  fi
  # tuigreet 0.9.1 persists "--remember*" state in /var/lib/greetd, so the
  # greeter needs group write there. tmpfiles resets ownership to
  # greetd:greetd on boot, but group permissions survive that reset.
  sudo chmod 770 /var/lib/greetd

  sudo tee /etc/greetd/config.toml >/dev/null <<'DMCFG'
[terminal]
vt = 7

[default_session]
command = "tuigreet --time --time-format '%H:%M  %d/%m/%Y' --greeting 'welcome back' --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --width 72 --container-padding 3 --window-padding 1 --theme 'border=cyan;text=white;container=black;title=cyan;greet=cyan;prompt=green;input=white;action=blue;button=cyan' --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot'"
user = "greeter"
DMCFG

  sudo systemctl disable --now gdm 2>/dev/null || true
  sudo systemctl enable greetd
  echo "> greetd+tuigreet enabled — logout/reboot to enter TUI login"
fi

if [ "$DO_DOCKER" = 1 ]; then
  need_sudo
  echo "> docker: installing Docker CE + compose plugin"
  sudo curl -fsSL https://download.docker.com/linux/fedora/docker-ce.repo \
    -o /etc/yum.repos.d/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER"
  echo "> docker installed"
fi

if [ "$DO_VIRT" = 1 ]; then
  need_sudo
  echo "> virt: installing virtualization group"
  sudo dnf install -y @virtualization
  sudo systemctl enable --now libvirtd
  sudo usermod -aG libvirt "$USER"
  echo "> virtualization installed"
fi

if [ "$DO_LAPTOP" = 1 ]; then
  need_sudo
  echo "> laptop: thermald + fwupd"
  sudo dnf install -y thermald fwupd
  sudo systemctl enable --now thermald
  echo "> laptop power/firmware services enabled"
fi

if [ "$DO_ZRAM" = 1 ]; then
  need_sudo
  echo "> zram: swap-on-zram via systemd-zram-generator"
  sudo dnf install -y systemd-zram-generator
  sudo tee /etc/systemd/zram-generator.conf >/dev/null <<'ZRAMEOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
ZRAMEOF
  sudo systemctl daemon-reload
  sudo systemctl start systemd-zram-setup@zram0.service 2>/dev/null || true
  echo "> zram enabled"
fi

if [ "$DO_HM" = 1 ]; then
  echo "> home-manager: building + switching fedora-btw"
  hm_attempts=0
  while :; do
    hm_attempts=$((hm_attempts + 1))
    logfile="$(mktemp)"
    set +o errexit
    nix --extra-experimental-features 'nix-command flakes' --accept-flake-config \
      run "$REPO"#homeConfigurations.fedora-btw.activationPackage 2>&1 | tee "$logfile"
    rc=${PIPESTATUS[0]}
    set -o errexit
    if [ "$rc" = 0 ]; then
      rm -f "$logfile"
      break
    fi
    clobbered="$(sed -n "s/^Existing file '\(.*\)' would be clobbered$/\1/p" "$logfile")"
    if [ -z "$clobbered" ]; then
      echo "error: home-manager switch failed (see output above)" >&2
      rm -f "$logfile"
      exit 1
    fi
    if [ "$hm_attempts" -ge 6 ]; then
      echo "error: too many clobber retries" >&2
      rm -f "$logfile"
      exit 1
    fi
    while IFS= read -r f; do
      [ -n "$f" ] || continue
      mv -f "$f" "$f.orig"
      echo "> backed up $f -> $f.orig (HM now manages it)"
    done <<< "$clobbered"
    rm -f "$logfile"
  done
fi

if [ "$DO_CONFIG" = 1 ]; then
  # if [ ! -s "$HOME/.terminfo/x/xterm-ghostty" ]; then
  #   echo "> installing xterm-ghostty terminfo (~/.terminfo) for remote tmux TERM"
  #   mkdir -p "$HOME/.terminfo/x"
  #   if command -v tic >/dev/null 2>&1; then
  #     tic -x -o "$HOME/.terminfo" "$REPO/config/terminfo/xterm-ghostty.ti"
  #   else
  #     cp -f /usr/share/terminfo/x/xterm-ghostty "$HOME/.terminfo/x/xterm-ghostty" 2>/dev/null || true
  #   fi
  # fi

  SW=0
  if [ -z "$FORCE_SOFTWARE" ]; then
    if [ ! -e /dev/dri/renderD128 ]; then
      SW=1
    elif command -v lspci >/dev/null 2>&1 && lspci | grep -qiE 'virtio|QXL|VMware SVGA'; then
      SW=1
    fi
  elif [ "$FORCE_SOFTWARE" = 1 ]; then
    SW=1
  fi
  echo "> software-gpu mode: $([ "$SW" = 1 ] && echo ON || echo off)"

  IS_INTEL=0
  if command -v lspci >/dev/null 2>&1 && lspci | grep -qi 'vga.*intel'; then
    IS_INTEL=1
  fi

  mkdir -p "$HOME/.config/labwc"

  {
    echo "# labwc session environment generated by setup-fedora.sh"
    echo "XKB_DEFAULT_LAYOUT=us"
    echo "TZ=Asia/Ho_Chi_Minh"
    echo "XCURSOR_THEME=breeze_cursors"
    echo "XCURSOR_SIZE=24"
    echo "GTK_IM_MODULE=fcitx"
    echo "QT_IM_MODULE=fcitx"
    echo "XMODIFIERS=@im=fcitx"
    echo "XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share:$HOME/.nix-profile/share"
    echo "MOZ_ENABLE_WAYLAND=1"
    echo "OZONE_PLATFORM=wayland"
    echo "NIXOS_OZONE_WL=1"
    echo "_JAVA_AWT_WM_NONREPARENTING=1"
    if [ "$IS_INTEL" = 1 ]; then
      echo "LIBVA_DRIVER_NAME=iHD"
    fi
    if [ "$SW" = 1 ]; then
      echo "WLR_RENDERER=pixman"
      echo "LIBGL_ALWAYS_SOFTWARE=1"
    fi
  } > "$HOME/.config/labwc/environment"

  echo "> ~/.config/labwc/environment written (GPU-detected)"
fi

if [ "$DO_SHELL" = 1 ]; then
  need_sudo
  {
    echo '#!/usr/bin/env bash'
    echo '# login wrapper: allows zsh from the nix store as a login shell'
    echo '# while sshd/pam can stat the path (symlink target otherwise fails).'
    echo 'case "$0" in'
    echo '  -*) exec "$HOME/.nix-profile/bin/zsh" -l "$@" ;;'
    echo '  *)  exec "$HOME/.nix-profile/bin/zsh" "$@" ;;'
    echo 'esac'
  } > /tmp/zzsh-wrapper.bash
  sudo cp -f /tmp/zzsh-wrapper.bash /usr/local/bin/zzsh
  sudo chmod 755 /usr/local/bin/zzsh
  if ! grep -qxF /usr/local/bin/zzsh /etc/shells; then
    echo /usr/local/bin/zzsh | sudo tee -a /etc/shells >/dev/null
  fi
  sudo chsh -s /usr/local/bin/zzsh "$USER"
  echo "> login shell set to /usr/local/bin/zzsh"
fi

echo "> done. Next: reboot -> GDM -> pick 'labwc' -> check noctalia bar/launcher,
#   fcitx5 Unikey in ghostty, and journalctl for pixman/EGL errors."
