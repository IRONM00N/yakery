{
  pkgs,
  config,
  lib,
  ...
}:
{
  systemd.user.services.kbuildsycoca6 = lib.mkIf config.host.hyprland {
    Unit = {
      Description = "Regenerate KDE service cache";
      After = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6";
    };
  };
}
