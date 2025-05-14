# also see: ./hosts/common/specializations/hyprland.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bundles.hyprland;
in
{
  options.bundles.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprland related config.";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      configPackages =
        with pkgs;
        lib.mkForce [
          hyprland
        ];
      extraPortals =
        with pkgs;
        lib.mkForce [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
    };

    environment.systemPackages = with pkgs; [
      hyprland
      hyprpicker
      kitty
      wofi
      cliphist
      brightnessctl
      hyprpicker
      hypridle
      hyprlock
      hyprshot
    ];
  };
}
