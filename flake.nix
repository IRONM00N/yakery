{
  description = "ironmoon's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  nixConfig = {
    extra-substituters = [
      "https://ironmoon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ironmoon.cachix.org-1:wowGL4TAzZPBO0fCqOekQLFqim3iXzdR+hIrK/tUadI="
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      plasma-manager,
      nixos-hardware,
      ...
    }:
    let
      base-config = {
        allowUnfree = true;
      };
      nixConfig = {
        nixpkgs.overlays = import ./overlays/default.nix;
        nixpkgs.config = base-config;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      base-modules = [
        nixConfig
        home-manager.nixosModule
      ];
      base-system = rec {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config = base-config;
          };
        };
      };

    in
    {

      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem (
          base-system
          // {
            modules = base-modules ++ [
              nixos-hardware.nixosModules.framework-13-7040-amd
              ./hosts/framework/configuration.nix
            ];
          }
        );
        desktop = nixpkgs.lib.nixosSystem (
          base-system
          // {
            modules = base-modules ++ [
              ./hosts/desktop/configuration.nix
            ];
          }
        );
      };
    };
}
