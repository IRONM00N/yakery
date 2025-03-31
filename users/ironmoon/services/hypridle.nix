{ info, ... }:
{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };

    listener = [
      {
        timeout = if info.laptop then 0.5 * 60 else 5 * 60;
        on-timeout = "brightnessctl -s set 10";
        on-resume = "brightnessctl -r";
      }
      {
        timeout = if info.laptop then 2.5 * 60 else 10 * 60;
        on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
        on-resume = "brightnessctl -rd rgb:kbd_backlight";
      }
      {
        timeout = if info.laptop then 5 * 60 else 30 * 60;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = if info.laptop then 5.5 * 60 else 30.5 * 60;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = if info.laptop then 30 * 60 else 2 * 60 * 60;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}
