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
    security.polkit.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    qt.enable = true;

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

    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;

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
