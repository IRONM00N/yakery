{
  config,
  pkgs,
  ...
}:
let
  common-settings = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "browser.tabs.groups.enabled" = true;
  };
in
{
  enable = true;

  # see policies in hosts/common/programs/firefox.nix

  profiles = {
    default = {
      id = 0;
      settings = common-settings;
    };

    dev-edition-default = {
      id = 1;
      settings = common-settings;
    };
  };
}
