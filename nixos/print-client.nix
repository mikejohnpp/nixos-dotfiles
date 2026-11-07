{ pkgs, ... }:

# Print client: in qua print server nix-homelab (HP LaserJet 400 MFP M425dn)
let
  printServer = "192.168.1.180"; # nix-homelab
in
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    browsing = false; # chỉ dùng máy in khai báo bên dưới, không tự quét mạng
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_M425dn";
        description = "HP LaserJet 400 MFP M425dn (nix-homelab)";
        location = "Home";
        deviceUri = "ipp://${printServer}:631/printers/HP_M425dn";
        model = "HP/hp-laserjet_400_mfp_m425-ps.ppd.gz";
        ppdOptions.PageSize = "A4";
      }
    ];
    ensureDefaultPrinter = "HP_M425dn";
  };
}
