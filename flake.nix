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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      base-system = rec {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;

          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
    in
    {
      nixConfig = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem (
          base-system
          // {
            modules = [
              home-manager.nixosModule
              ./hosts/framework/configuration.nix
            ];
          }
        );
        desktop = nixpkgs.lib.nixosSystem (
          base-system
          // {
            modules = [
              home-manager.nixosModule
              ./hosts/desktop/configuration.nix
            ];
          }
        );
      };
    };
}
