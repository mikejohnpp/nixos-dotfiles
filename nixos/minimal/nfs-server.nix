{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
  ];

  services.nfs.server = {
    enable = true;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = "";
  };
  networking.firewall = {
    enable = true;
    # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };
  exports = "/data *(rw,sync,no_subtree_check,no_root_squash)";
}
