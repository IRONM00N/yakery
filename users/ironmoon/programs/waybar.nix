{ ... }:
{
  enable = true;

  settings = {
    mainBar = {
      "layer" = "top";
      "position" = "top";

      "spacing" = 2;

      "height" = 30;

      "modules-left" = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      "modules-center" = [
        "clock"
      ];

      "modules-right" = [
        "tray"

        "cpu"
        "memory"
        "temperature"
        "backlight"

        # "network"
        "pulseaudio"

        "power-profiles-daemon"
        "idle_inhibitor"
        "battery"
      ];

      "hyprland/workspaces" = {
        "format" = "{icon}";
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
      };

      "hyprland/window" = {
        "separate-outputs" = true;
        "max-length" = 150;
      };

      # -----------------

      "clock" = {
        "interval" = 1;
        "format" = "{:%a %Y-%m-%d %H:%M:%S}";
        "on-click" = "";
        "on-click-middle" = "";
        "on-click-right" = "";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
      };

      # -----------------

      "tray" = {
        "spacing" = 0;
      };

      # "cpu" = {
      #   "format" = "{usage}% ";
      # };
      "cpu" = {
        "interval" = 1;
        "format" = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
        "format-icons" = [
          " "
          "<span color='#69ff94'>▁</span>" # green
          "<span color='#2aa9ff'>▂</span>" # blue
          "<span color='#f8f8f2'>▃</span>" # white
          "<span color='#f8f8f2'>▄</span>" # white
          "<span color='#ffffa5'>▅</span>" # yellow
          "<span color='#ffffa5'>▆</span>" # yellow
          "<span color='#ff9977'>▇</span>" # orange
          "<span color='#dd532e'>█</span>" # red
        ];
      };
      "memory" = {
        "format" = "{}% ";
      };
      "temperature" = {
        "critical-threshold" = 80;
        "format" = "{temperatureC}°C {icon}";
        "format-icons" = [
          ""
          ""
          ""
        ];
      };
      "backlight" = {
        "format" = "{percent}% {icon}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "network" = {
        "format-wifi" = "{essid} ({signalStrength}%) ";
        "format-ethernet" = "{ipaddr}/{cidr} 󰈀";
        "tooltip-format" = "{ifname} via {gwaddr} 󰈀";
        "format-linked" = "{ifname} (No IP) 󰈀";
        "format-disconnected" = "Disconnected ⚠";
        "format-alt" = "{ifname}: {ipaddr}/{cidr}";
      };

      "pulseaudio" = {
        "scroll-step" = 5;
        "format" = "{volume}% {icon} {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = "󰝟 {icon} {format_source}";
        "format-muted" = "󰝟 {format_source}";
        "format-source" = "{volume}% ";
        "format-source-muted" = " ";
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "󰋎";
          "headset" = "󰋎";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [
            ""
            ""
            ""
          ];
        };
        "on-click" = "pwvucontrol";
      };

      "power-profiles-daemon" = {
        "format" = "{icon}";
        "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
        "tooltip" = true;
        "format-icons" = {
          # "default" = "";
          "performance" = "";
          # these are rendered too large
          "balanced" = " ";
          "power-saver" = " ";
        };
      };
      "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
          "activated" = "";
          "deactivated" = "";
        };
      };
      "battery" = {
        "interval" = 15;
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-plugged" = "{capacity}% ";
        "tooltip" = true;
        "tooltip-format" = "{timeTo}\nCycles: {cycles}\nHealth: {health}%\nPower: {power}W";
        "format-icons" = {
          charging = [
            "󰢟"
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
      };

    };
  };

  style = builtins.readFile ../resources/waybar.css;

  systemd.enable = false;
}
