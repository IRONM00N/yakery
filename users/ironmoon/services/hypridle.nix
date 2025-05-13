{ info, pkgs, ... }:
let
  durations = { laptop, desktop }: builtins.floor (if info.laptop then laptop else desktop);
in
{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };

    listener =
      [
        {
          timeout = durations {
            laptop = 0.5 * 60;
            desktop = 5 * 60;
          };
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = durations {
            laptop = 2.5 * 60;
            desktop = 10 * 60;
          };
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = durations {
            laptop = 5 * 60;
            desktop = 30 * 60;
          };
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = durations {
            laptop = 5.5 * 60;
            desktop = 30.5 * 60;
          };
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ]
      ++ pkgs.lib.optional info.laptop {
        timeout = 30 * 60;
        on-timeout = "systemctl suspend";
      };
  };
}
