{ ... }:
{
  enable = true;

  settings = {
    mainBar = {
      "layer" = "top";
      "position" = "top";

      "height" = 30;

      "modules-left" = [
        "hyprland/workspaces"
        "hyprland/mode"
        # "hyprland/scratchpad"
        "hyprland/window"
      ];

      "modules-center" = [
        "clock"
      ];

      "modules-right" = [
        "network"

        "cpu"
        # "keyboard-state"
        "power-profiles-daemon"
        "battery"
      ];

      "hyprland/workspaces" = {
        "format" = "{icon}";
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
      };

      "hyprland/window" = {
        "separate-outputs" = true;
      };

      # keyboard-state = {
      #   capslock = true;
      #   format = "{icon}";
      #   format-icons = {
      #     locked = "Caps ";
      #     unlocked = "";
      #   };
      # };

      # "clock" = {
      #   # "timezone" = "America/New_York";
      #   "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      #   "format-alt" = "{:%Y-%m-%d}";
      # };

      "clock" = {
        "interval" = 1;
        "format" = "{:%a %Y-%m-%d %H:%M:%S}";
        "on-click" = "";
        "on-click-middle" = "";
        "on-click-right" = "";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
      };

      "battery" = {
        "states" = {
          # good = 95;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-full" = "{capacity}% {icon}";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "{capacity}% ";
        "format-alt" = "{time} {icon}";
        # "format-good" = ""; # An empty format will hide the module
        # "format-full" = "";
        "format-icons "= [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "power-profiles-daemon" = {
        "format" = "{icon}";
        "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
        "tooltip" = true;
        "format-icons" = {
          "default" = "";
          "performance" = "";
          "balanced" = "";
          "power-saver" = "";
        };
      };

      "network" = {
        # interface = "wlp2*"; # (Optional) To force the use of this interface
        "format-wifi" = "{essid} ({signalStrength}%) ";
        "format-ethernet" = "{ipaddr}/{cidr} ";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "format-linked" = "{ifname} (No IP) ";
        "format-disconnected" = "Disconnected ⚠";
        "format-alt" = "{ifname}: {ipaddr}/{cidr}";
      };
    };
  };

  style = builtins.readFile ../resources/waybar.css;

  systemd.enable = false;
}
