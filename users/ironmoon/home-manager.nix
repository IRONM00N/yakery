{
  inputs,
  config,
  lib,
  pkgs,
  pkgs-stable,
  host,
  ...
}:
let
  importMod =
    path:
    import path {
      inherit
        inputs
        config
        lib
        pkgs
        pkgs-stable
        ;
    };
  symlink = config.lib.file.mkOutOfStoreSymlink;
  dot-root = "/etc/nixos/users/ironmoon/resources/";
in
{
  imports = [
    ../../hosts/options.nix
    ./services/network-manager-applet.nix
    ./services/kbuildsycoca6.nix
  ];

  host = host;

  home.file.".p10k.zsh".source = symlink "${dot-root}/.p10k.zsh";

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar";
    VISUAL = "${pkgs.vscode}/bin/code --wait --new-window";
    SUDO_EDITOR = "${pkgs.vscode}/bin/code --wait --new-window --disable-workspace-trust";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
  };

  # qt = {
  #   enable = false;
  #   style = {
  #     name = "breeze";
  #     package = pkgs.kdePackages.breeze;
  #   };
  # };

  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };

    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze";
    };
  };

  dconf = {
    enable = false;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  xdg.enable = true;
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
    hyprpaper = importMod ./services/hyprpaper.nix;
    hyprpolkitagent = importMod ./services/hyprpolkitagent.nix;
  };

  programs.plasma = importMod ./env/plasma.nix;
  wayland.windowManager.hyprland = importMod ./env/hyprland.nix;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
