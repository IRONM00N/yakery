{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bundles.displaylink;
in
{
  options.bundles.displaylink = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable display link drivers.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.displaylink
    ];

    services.xserver.videoDrivers = [
      "displaylink"
      "modesetting"
    ];

    systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  };
}
