{
  description = "ironmoon's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      base-system = {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
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
