{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./custom.nix
    #    ./../../modules/home-manager/mysql.nix
  ];

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

  networking.networkmanager.dns = "none";
  networking.resolvconf.enable = false;

  time.timeZone = "Asia/Ho_Chi_Minh";

  wsl = {
    enable = true;
    defaultUser = "mikejohnp";
    startMenuLaunchers = true;
    useWindowsDriver = true;
    wslConf = {
      automount.enabled = true;
      automount.ldconfig = true;
    };
    interop.register = true;
    interop.includePath = true;
  };

  # services.xserver.enable = true;
  # services.xserver.displayManager.startx.enable = true;
  #
  # services.xserver.windowManager.i3.enable = true;
  # services.xserver.displayManager.defaultSession = "none+i3";
  # services.xserver.videoDrivers = [ "modesetting" ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "mikejohnp";
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";

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

  users.users.mikejohnp = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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
    git
    mesa-demos
    xclip
    xsel
    psmisc
  ];

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh.enable = true;

  # Workaround for hardware acceleration on NixOS-WSL
  # https://github.com/nix-community/NixOS-WSL/issues/454
  environment.sessionVariables.LD_LIBRARY_PATH = [ "/run/opengl-driver/lib/" ];
  environment.sessionVariables.GALLIUM_DRIVER = "d3d12";
  environment.sessionVariables.MESA_D3D12_DEFAULT_ADAPTER = 0;
  system.stateVersion = "25.05";
}
