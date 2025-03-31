{ info, ... }:
let
  night-landscape = builtins.toString (
    builtins.path {
      path = ../resources/wallpapers/night-landscape.jpg;
      name = "night-landscape.jpg";
    }
  );
in
{
  enable = true;
  settings = {
    auth = {
      "pam:enabled" = true;
      "fingerprint:enabled" = info.fingerprint;
    };

    background = [
      {
        path = "${night-landscape}";
        blur_passes = 1;
        blur_size = 8;
      }
    ];

    input-field = [
      {
        size = "300, 50";
        position = "0, 0";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(82, 116, 188)"; # rgb(82, 116, 188)
        outer_color = "rgb(4, 58, 104)"; # rgb(4, 58, 104)
        # #0A0019
        outline_thickness = 4;
        rounding = 4;
        placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
      }
    ];

    label = [
      {
        text = "$TIME";
        position = "0, 250";
        color = "rgb(202, 211, 245)";
        font_size = 64;
        font_family = "Noto Sans";
        halign = "center";
        valign = "center";
      }
      # {
      #   text = "$PAMPROMPT";
      #   position = "0, -30";
      #   color = "rgb(202, 211, 245)";
      #   font_size = 18;
      #   font_family = "Noto Sans";
      #   halign = "center";
      #   valign = "center";
      # }
      {
        text = "$FPRINTPROMPT";
        position = "0, -100";
        color = "rgb(202, 211, 245)";
        font_size = 10;
        font_family = "Noto Sans";
        halign = "center";
        valign = "center";
      }
      {
        text = "$PAMFAIL";
        position = "0, -115";
        color = "rgb(255, 100, 100)";
        font_size = 10;
        font_family = "Noto Sans";
        halign = "center";
        valign = "center";
      }
      {
        text = "$FPRINTFAIL";
        position = "0, -130";
        color = "rgb(255, 100, 100)";
        font_size = 10;
        font_family = "Noto Sans";
        halign = "center";
        valign = "center";
      }
    ];

    # animations.enabled = true;
  };
}
