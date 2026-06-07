{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  background-image = pkgs.runCommand "background-image" { } ''
    cp ${../../config/bg/cg02_1.png} $out
  '';
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
    themeConfig = {
      Background = "${background-image}";
      Font = "JetBrainsMono Nerd Font";

      PartialBlur = "true";
      # Default false.
      FullBlur = "false";
      # Default false.
      # If you use FullBlur I recommend setting BlurMax to 64 and Blur to 1.0.
      BlurMax = "36";
      # Default 48, Options: 2-64 (can go higher because depends on Blur).
      # Connected with: Blur.
      Blur = "1.5";
      # Default 2.0, Options: 0.0-3.0 (without 3.0).
      # Connected with: BlurMax.

      HaveFormBackground = "true";
      # Form background is transparent if set to false.
      # Connected with: PartialBlur and BackgroundColor.
      FormPosition = "left";
      # Default: left, Options: left, center, right.

      #################### Colors ####################

      HeaderTextColor = "#ddeeff";
      DateTextColor = "#ddeeff";
      TimeTextColor = "#ddeeff";

      FormBackgroundColor = "#0d1830";
      BackgroundColor = "#0d1830";
      DimBackgroundColor = "#080f20";

      LoginFieldBackgroundColor = "#0a1428";
      PasswordFieldBackgroundColor = "#0a1428";
      LoginFieldTextColor = "#ddeeff";
      PasswordFieldTextColor = "#ddeeff";
      UserIconColor = "#c8e0ff";
      PasswordIconColor = "#c8e0ff";

      PlaceholderTextColor = "#6688aa";
      WarningColor = "#cc2244";

      LoginButtonTextColor = "#f0f8ff";
      LoginButtonBackgroundColor = "#cc2244";
      SystemButtonsIconsColor = "#c8e0ff";
      SessionButtonTextColor = "#c8e0ff";
      VirtualKeyboardButtonTextColor = "#c8e0ff";

      DropdownTextColor = "#f0f8ff";
      DropdownSelectedBackgroundColor = "#cc2244";
      DropdownBackgroundColor = "#1a2a4a";

      HighlightTextColor = "#f0f8ff";
      HighlightBackgroundColor = "#cc2244";
      HighlightBorderColor = "transparent";

      HoverUserIconColor = "#ffffff";
      HoverPasswordIconColor = "#ffffff";
      HoverSystemButtonsIconsColor = "#ffffff";
      HoverSessionButtonTextColor = "#ffffff";
      HoverVirtualKeyboardButtonTextColor = "#ffffff";
    };
  };

in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./custom.nix
    ../../modules/home-manager/mysql.nix

  ];

  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "splash"
      "console=/dev/null"
    ];
    extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
    kernelModules = [
      "msi-ec"
      "ec_sys"
    ];

    plymouth.enable = true;
  };

  specialisation = {
    kernmainline.configuration = {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    };

    xanmod.configuration = {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
    };

  };

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ ];

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
  # networking.networkmanager.dns = "none";
  networking.resolvconf.enable = true;
  # networking.enableIPv6 = false;

  time.timeZone = "Asia/Ho_Chi_Minh";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.xserver = {
    enable = false;
    xkb.layout = "us";
    xkb.variant = "";
  };

  services = {
    displayManager = {
      sddm = {
        enable = true;
        extraPackages = [
          custom-sddm-astronaut
        ];

        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
          };
        };
        wayland.enable = true;

      };
    };
  };

  programs.niri.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # services.sunshine = {
  #   enable = true;
  #   autoStart = true;
  #   capSysAdmin = true;
  #   openFirewall = true;
  # };

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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Use the engine from qt6Packages
      addons = with pkgs; [
        fcitx5-gtk # Specifically keep this for Brave/Firefox
        qt6Packages.fcitx5-unikey
        fcitx5-bamboo
      ];
      waylandFrontend = true;
    };
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = lib.mkForce "fcitx";
    QT_IM_MODULE = lib.mkForce "fcitx";
    XMODIFIERS = "@im=fcitx";
    NIXOS_OZONE_WL = "1";
    #   # # Force browsers to use X11
    #   # MOZ_ENABLE_WAYLAND = "0";
    #   # ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };
  #
  # # Add this if you use Brave or Google Chrome
  programs.chromium.extraOpts = {
    enable = true;
    extraArgs = [
      "--gtk-version=4"
      # "--disable-features=WaylandFractionalScaleV1"
      # "--enable-features=UseOzonePlatform"
      # "--ozone-platform=x11"
    ];
  };

  hardware.uinput.enable = true;

  users.users.mikejohnp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "uinput"
      "audio"
      "docker"
      "gamemode"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    (with pkgs; [
      gnumake
      lsof
      vim
      wget
      tree
      gh
      gcc
      home-manager
      libva-utils
      pulseaudio
      pipewire
      alsa-tools
      pavucontrol
      git
      xwayland-satellite
      psmisc
      nautilus
      custom-sddm-astronaut
      kdePackages.qtmultimedia
    ])
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      opencode
      gemini-cli
      pi
    ]);

  fonts.packages = with pkgs; [
    corefonts # Msfont support
    nerd-fonts.jetbrains-mono
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    accept-flake-config = true;
  };

  nix.settings.trusted-users = [
    "root"
    "@wheel"
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    MOZ_ENABLE_WAYLAND = "1";
    OZONE_PLATFORM = "wayland";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.upower.enable = true; # Battery stuff
  services.udisks2.enable = true;

  services.cloudflare-warp.enable = false;

  programs.xfconf.enable = true;
  programs.nix-ld.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GiB
    }
  ];
  system.stateVersion = "26.05";

}
