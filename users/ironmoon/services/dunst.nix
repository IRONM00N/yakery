{ config, ... }:
{
  enable = config.host.hyprland;

  settings = {
    global = {
      enable_posix_regex = true;

      follow = "mouse";

      origin = "top-right";
      offset = "(0, 0)"; # doesn't include waybar (won't overlap)
    };
  };
}
