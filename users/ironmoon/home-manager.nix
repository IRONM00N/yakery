{
  inputs,
  config,
  pkgs,
  ...
}:
{
  home.file.".p10k.zsh".source = ./resources/.p10k.zsh;

  gtk.theme = "Breeze";

  xdg.mimeApps = {
    enable = false;
    associations = {
      added = {
        "application/pdf" = "firefox.desktop";
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
    zsh = import ./programs/zsh.nix { inherit inputs config pkgs; };
    plasma = import ./programs/plasma.nix { inherit inputs config pkgs; };
    konsole = import ./programs/konsole.nix { inherit inputs config pkgs; };
    okular = import ./programs/okular.nix { inherit inputs config pkgs; };
    git = import ./programs/git.nix { inherit inputs config pkgs; };
    firefox = import ./programs/firefox.nix { inherit inputs config pkgs; };
    direnv = import ./programs/direnv.nix { inherit inputs config pkgs; };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
