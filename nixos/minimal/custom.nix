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
    pkgs.home-manager
  ];

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.lazydocker
    # pkgs.tlrc
  ];

  hardware.enableRedistributableFirmware = false;
  hardware.enableAllFirmware = false;
  hardware.firmware = [ ];

  programs.zsh = {
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  services.zerotierone = {
    enable = true;
  };

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup
    extraSetFlags = [
      "--accept-dns=false"
      # "--relay-server-port=40000"
    ];

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";

  };

  # Garbage Collector Setting
  nix.gc.automatic = false;

  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
}
