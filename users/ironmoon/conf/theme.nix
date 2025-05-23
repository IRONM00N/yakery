{ pkgs, ... }:
{
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
}
