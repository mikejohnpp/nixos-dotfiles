{
  description = "NixOs from scratch MikeJohnP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkNixosConfig =
        system: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixos-btw = mkNixosConfig "x86_64-linux" [
          ./nixos/vm-dev/configuration.nix
        ];

        desk-btw = mkNixosConfig "x86_64-linux" [
          ./nixos/desk/configuration.nix
        ];

        wsl-btw = mkNixosConfig "x86_64-linux" [
          ./nixos/wsl-dev/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
        ];

        minimal-btw = mkNixosConfig "x86_64-linux" [
          ./nixos/minimal/configuration.nix
        ];
      };

      homeConfigurations = {
        "nixos-btw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/vm-dev/home.nix
          ];
        };

        "desk-btw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/desk-dev/home.nix
            inputs.noctalia.homeModules.default
          ];
        };

        "wsl-btw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/wsl-dev/home.nix
          ];
        };

        "minimal-btw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/minimal/home.nix
          ];
        };
      };

    };

}
