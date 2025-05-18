{
  pkgs,
  config,
  lib,
  ...
}:
{
  # systemd.user.services.hyprpolkitagent = lib.mkIf config.host.hyprland {
  #   Unit = {
  #     Description = "Hyprland Polkit Authentication Agent";
  #     After = [ "graphical-session@Hyprland.target" ];
  #     PartOf = [ "graphical-session@Hyprland.target" ];
  #     ConditionEnvironment = "WAYLAND_DISPLAY";
  #   };

  #   Install = {
  #     WantedBy = [ "graphical-session@Hyprland.target" ];
  #   };

  #   Service = {
  #     ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
  #     Slice = "session.slice";
  #     TimeoutStopSec = "5sec";
  #     Restart = "on-failure";
  #   };
  # };

  services.hyprpolkitagent.enable = true;
}
