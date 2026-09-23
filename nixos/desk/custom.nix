{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.mikejohnp.packages = lib.mkDefault [
    pkgs.vim
    pkgs.alsa-tools
    pkgs.home-manager
  ];

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.lazydocker
    pkgs.tlrc
    pkgs.dnsmasq
    (pkgs.writeShellScriptBin "steam" ''
      exec ${pkgs.steam}/bin/steam -system-composer
    '')
  ];

  programs.zsh = {
    enable = true;
  };

  # programs = {
  #   gamescope = {
  #     enable = true;
  #     capSysNice = true;
  #   };
  #   steam = {
  #     enable = true;
  #     dedicatedServer.openFirewall = true;
  #     gamescopeSession = {
  #       enable = true;
  #     };
  #
  #     extraCompatPackages = with pkgs; [
  #       proton-ge-bin
  #     ];
  #     package = pkgs.steam.override {
  #       extraPkgs =
  #         pkgs': with pkgs'; [
  #           libXcursor
  #           libXi
  #           libXinerama
  #           libXScrnSaver
  #           libpng
  #           libpulseaudio
  #           libvorbis
  #           stdenv.cc.cc.lib # Provides libstdc++.so.6
  #           libkrb5
  #           keyutils
  #           # Add other libraries as needed
  #         ];
  #     };
  #   };
  #   gamemode.enable = true;
  # };

  hardware.enableRedistributableFirmware = true;

  hardware.enableAllFirmware = true;
  hardware.firmware = [
    pkgs.linux-firmware
    pkgs.sof-firmware
  ];

  services.fwupd.enable = true;

  powerManagement.enable = true;

  services.thermald.enable = true;

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;
  #
  #     #Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #
  #   };
  # };

  services.dbus.packages = [ pkgs.mcontrolcenter ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  programs.virt-manager.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  # systemd.user.services.mcontrolcenter = {
  #   description = "Auto start mcontrolcenter";
  #   wantedBy = [ "default.target" ];
  #
  #   serviceConfig = {
  #     ExecStart = "${pkgs.mcontrolcenter}/bin/mcontrolcenter";
  #     Restart = "on-failure";
  #   };
  # };

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    extraSetFlags = [
      "--accept-dns=false"
    ];
    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";

  };

  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  # boot.loader.systemd-boot.configurationLimit = 5;

  # Garbage Collector Setting
  nix.gc.automatic = false;

  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
}
