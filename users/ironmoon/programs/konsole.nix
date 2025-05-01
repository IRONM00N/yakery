{
  config,
  pkgs,
  ...
}:
{
  enable = true;
  defaultProfile = "Echo Chamber";
  profiles = {
    "Echo Chamber" = {
      font = {
        size = 10;
      };
      colorScheme = "Campbell";
      extraConfig = {
        "Scrolling" = {
          "HistoryMode" = "2";
        };
        "Appearance" = {
          ColorScheme = "Campbell";
          # don't use mono, otherwise icons are too small.
          Font = "FiraCode Nerd Font Ret";
          # However, this seems cause bolded text to take up too much space (unlike the mono variant)
          # this means that we need to disable bolding in the font settings
          BoldIntense = "false";
        };
        "Cursor Options" = {
          CursorShape = "1";
        };
      };
    };
  };
  customColorSchemes = {
    # ported from windows terminal
    Campbell = ../resources/Campbell.colorscheme;
  };
}
