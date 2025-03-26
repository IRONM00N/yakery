{
  inputs,
  config,
  pkgs,
  info,
  ...
}:
let
  importMod =
    path:
    import path {
      inherit
        inputs
        config
        pkgs
        info
        ;
    };
in
{
  home.file.".p10k.zsh".source = ./resources/.p10k.zsh;

  gtk.theme = "Breeze";

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

  programs = {
    zsh = importMod ./programs/zsh.nix;
    konsole = importMod ./programs/konsole.nix;
    okular = importMod ./programs/okular.nix;
    git = importMod ./programs/git.nix;
    firefox = importMod ./programs/firefox.nix;
    direnv = importMod ./programs/direnv.nix;

    waybar = importMod ./programs/waybar.nix;
    hyprlock = importMod ./programs/hyprlock.nix;
    kitty = importMod ./programs/kitty.nix;
    anyrun = importMod ./programs/anyrun.nix;
  };

  services = {
    dunst = importMod ./services/dunst.nix;
    hypridle = importMod ./services/hypridle.nix;
  };
  imports = [ ./services/network-manager-applet.nix ];

  programs.plasma = importMod ./env/plasma.nix;
  wayland.windowManager.hyprland = importMod ./env/hyprland.nix;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
