# AGENTS.md

## Scope
This file applies to the whole repository (`nixos-dotfiles`).

## Project Purpose
This repo contains a personal NixOS + Home Manager setup with multiple machine targets:
- `desk-btw` (desktop, Niri/Wayland)
- `nixos-btw` (VM dev profile, i3/X11)
- `wsl-btw` (NixOS-WSL)
- `minimal-btw` (minimal server-like profile, includes k3s)

## Repository Layout
- `flake.nix`: main entrypoint (NixOS + Home Manager outputs)
- `nixos/<target>/`: system-level NixOS configs per host
- `users/<target>/`: Home Manager user profiles per host
- `modules/home-manager/`: reusable HM modules
- `config/`: dotfiles synced by HM modules (nvim, niri, tmux, etc.)
- `bin/`: helper scripts (e.g. screenshot helper)
- `nixshell/`: standalone dev shells (Android, clang)
- `helm/`: Kubernetes/Helm manifests/templates

## How Configuration Is Wired
1. `flake.nix` defines `nixosConfigurations` and `homeConfigurations`.
2. Host system config imports `nixos/<target>/configuration.nix` (+ local `custom.nix`).
3. User profile imports `users/<target>/home.nix`.
4. HM modules under `modules/home-manager/*` expose `within.<name>.enable` options.
5. Enabled modules link/copy files from `config/*` into `$HOME/.config/*`.

## Safe Change Strategy
When making changes, prefer the smallest scope:
- **Feature in one app dotfile** → edit `config/...`
- **Enable/disable app integration** → edit `users/<target>/home.nix` toggles/imports
- **Reusable behavior across profiles** → edit `modules/home-manager/...`
- **System service/kernel/networking** → edit `nixos/<target>/configuration.nix` or `custom.nix`

## Commands (Common)
From repo root:
- Build NixOS config only:
  - `sudo nixos-rebuild build --flake .#desk-btw`
  - `sudo nixos-rebuild build --flake .#nixos-btw`
  - `sudo nixos-rebuild build --flake .#wsl-btw`
  - `sudo nixos-rebuild build --flake .#minimal-btw`
- Switch Home Manager profile:
  - `home-manager switch --flake .#desk-btw`
  - `home-manager switch --flake .#nixos-btw`
  - `home-manager switch --flake .#wsl-btw`
  - `home-manager switch --flake .#minimal-btw`
- Evaluate outputs:
  - `nix flake show`

## Style & Editing Conventions
- Keep existing formatting style per file (Nix/Lua/TOML/KDL/JSON/Shell).
- Make focused edits; avoid unrelated refactors.
- Do not reorder large lists unless requested (packages, extensions, keymaps).
- `flake.lock` should only be changed when dependency updates are requested.
- `helm/argoCD/values.yaml` is a very large upstream-style values file; prefer minimal targeted key edits.

## Important Repo-Specific Notes
- Neovim config is modular under `config/neovim/lua/config/plugins/*`.
- Java/JDTLS has multiple setup files (`jdtls_setup*.lua` + `ftplugin/java.lua`); treat them as experimental alternatives unless asked to consolidate.
- Desktop setups differ significantly:
  - `desk`: Niri/Wayland + Noctalia + Vicinae
  - `vm-dev`: i3/X11 + picom
  - `wsl`: no normal Linux display stack by default
- Some comments are in Vietnamese; keep them unless explicitly asked to translate.

## Validation Expectations After Changes
If you change Nix code:
- At minimum run a build/eval command for the affected target.
If you change app configs only (e.g., nvim/tmux/niri):
- Prefer lightweight syntax/sanity checks where possible.

## What Not To Do
- Don’t migrate architecture (e.g., rewrite module structure) unless requested.
- Don’t globally format all files.
- Don’t remove seemingly duplicated configs without confirmation (this repo keeps alternatives intentionally).
