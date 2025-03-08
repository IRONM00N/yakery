# adapted from home-manager's network-manager-applet modules -- limit to only
# targeting Hyprland
{ pkgs, ... }:
{
  xdg.systemDirs.data = [ "${pkgs.networkmanagerapplet}/share" ];

  systemd.user.services.network-manager-applet = {
    Unit = {
      Description = "Network Manager applet";
      Requires = [ "tray.target" ];
      After = [
        "graphical-session-pre@Hyprland.target"
        "tray.target"
      ];
      PartOf = [ "graphical-session@Hyprland.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session@Hyprland.target" ];
    };

    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };
  };
}
