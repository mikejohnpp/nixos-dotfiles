{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./custom.nix
  ];

  services.xserver.videoDrivers = [ "modesetting" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    5912
    5901
  ];

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
  # networking.networkmanager.dns = "none";
  # networking.resolvconf.enable = false;

  time.timeZone = "Asia/Ho_Chi_Minh";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };

  programs.niri.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.uinput.enable = true;

  users.users.mikejohnp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "uinput"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    lsof
    vim
    wget
    tree
    gh
    gcc
    home-manager
    pulseaudio
    pipewire
    alsa-tools
    pavucontrol
    git
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh.enable = true;

  # Hardware specific
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # 3. Clean up the Graphics warnings (from your earlier log)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver # This is the new name for vaapiVdpau
      libvdpau-va-gl
      mesa
    ];
  };
  system.stateVersion = "25.05";

}
