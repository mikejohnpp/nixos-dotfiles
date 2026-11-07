{ pkgs, ... }:

# Print server: HP LaserJet 400 MFP M425dn (USB)
{
  # CUPS usb backend talks to the printer via libusb; usblp keeps stealing the
  # interface back (job stuck on "Waiting for printer to become available").
  boot.blacklistedKernelModules = [ "usblp" ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    browsing = true;
    defaultShared = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_M425dn";
        description = "HP LaserJet 400 MFP M425dn";
        location = "Home";
        deviceUri = "usb://HP/LaserJet%20400%20MFP%20M425dn?serial=CNF8H7HDX2";
        model = "HP/hp-laserjet_400_mfp_m425-ps.ppd.gz";
        ppdOptions.PageSize = "A4";
      }
    ];
    ensureDefaultPrinter = "HP_M425dn";
  };
}
