{ ... }:
{
  enable = false;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };

    listener = [
      {
        timeout = 2.5 * 60;
        on-timeout = "brightnessctl -s set 10";
        on-resume = "brightnessctl -r";
      }
      {
        timeout = 2.5 * 60;
        on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
        on-resume = "brightnessctl -rd rgb:kbd_backlight";
      }
      {
        timeout = 5 * 60;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = 5.5 * 60;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 30 * 60;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}
