{ pkgs, ... }:
{
  xdg.enable = true;
  xdg.userDirs.enable = true;

  home.preferXdgDirectories = true;

  # TODO: work on making these specialized for each DE
  # hyprland enables home-manager xdg config, while plasma doesn't. So we need to
  # set all these here.
  xdg.portal = {
    xdgOpenUsePortal = true;
    configPackages =
      with pkgs;
      lib.mkForce [
        kdePackages.plasma-workspace
        hyprland
      ];
    extraPortals =
      with pkgs;
      lib.mkForce [
        kdePackages.kwallet
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
  };

  xdg.mimeApps = {
    enable = false;
    /*
      [Added Associations]
      application/pdf=okular.desktop;firefox.desktop;
      application/x-extension-htm=firefox.desktop;
      application/x-extension-html=firefox.desktop;
      application/x-extension-shtml=firefox.desktop;
      application/x-extension-xht=firefox.desktop;
      application/x-extension-xhtml=firefox.desktop;
      application/x-ipynb+json=code.desktop;
      application/xhtml+xml=firefox.desktop;
      inode/directory=org.kde.dolphin.desktop;code.desktop;
      text/html=firefox.desktop;
      x-scheme-handler/chrome=firefox.desktop;
      x-scheme-handler/http=firefox.desktop;
      x-scheme-handler/https=firefox.desktop;
      x-scheme-handler/mailto=userapp-Thunderbird-1X23W2.desktop;
      x-scheme-handler/mid=userapp-Thunderbird-1X23W2.desktop;

      [Default Applications]
      application/pdf=okular.desktop;
      application/x-extension-htm=firefox.desktop
      application/x-extension-html=firefox.desktop
      application/x-extension-shtml=firefox.desktop
      application/x-extension-xht=firefox.desktop
      application/x-extension-xhtml=firefox.desktop
      application/x-ipynb+json=code.desktop;
      application/xhtml+xml=firefox.desktop
      inode/directory=org.kde.dolphin.desktop;
      message/rfc822=userapp-Thunderbird-1X23W2.desktop
      text/html=firefox.desktop;
      x-scheme-handler/chrome=firefox.desktop
      x-scheme-handler/http=firefox.desktop
      x-scheme-handler/https=firefox.desktop
      x-scheme-handler/mailto=userapp-Thunderbird-1X23W2.desktop
      x-scheme-handler/mid=userapp-Thunderbird-1X23W2.desktop
      x-scheme-handler/slack=slack.desktop
      x-scheme-handler/discord=vesktop.desktop
    */
    associations = {
      added = {
        "application/pdf" = "okular.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-ipynb+json" = "code.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "inode/directory" = [
          "org.kde.dolphin.desktop"
          "code.desktop"
        ];
        "text/html" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "thunderbird.desktop";
        "x-scheme-handler/mid" = "thunderbird.desktop";
      };
    };
  };

}
