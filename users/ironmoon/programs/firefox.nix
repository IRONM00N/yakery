{
  config,
  pkgs,
  ...
}:
{
  enable = true;

  # see policies in hosts/common/programs/firefox.nix

  profiles = {
    default = {
      id = 0;
      isDefault = true;
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.tabs.groups.enabled" = true;
      };
    };
  };

}
