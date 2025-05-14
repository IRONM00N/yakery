{ lib, ... }:
with lib;
{
  options.host = {
    id = mkOption {
      type = types.str;
      description = "Unique identifier for this machine";
    };

    hostname = mkOption {
      type = types.str;
      description = "Hostname of this machine";
      default = "nixos";
    };

    laptop = mkOption {
      type = types.bool;
      default = false;
      description = "Is a laptop";
    };

    fingerprint = mkOption {
      type = types.bool;
      default = false;
      description = "Supports fingerprint authentication";
    };

    kde = mkOption {
      type = types.bool;
      default = false;
      description = "KDE Plasma is used";
    };

    hyprland = mkOption {
      type = types.bool;
      default = false;
      description = "Hyprland is used";
    };

    nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "shitty graphics card";
    };
  };
}
