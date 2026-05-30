{ config, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    settings = {
      mysqld = {
        bind-address = "0.0.0.0";
        port = 3307;
        character-set-server = "utf8mb4";
        collation-server = "utf8mb4_unicode_ci";
      };
    };
  };

  # networking.firewall.allowedTCPPorts = [ 3306 ];
}
