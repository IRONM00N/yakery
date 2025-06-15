args@{
  pkgs,
  host,
  config,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  my-modules = import ./modules/default.nix;
  bundles = import ./bundles/default.nix;
  importWith = path: import path args;
in
{
  imports =
    [
      ../../hosts/options.nix
      ./services/network-manager-applet.nix
      ./services/kbuildsycoca6.nix
      ./conf/theme.nix
      ./conf/xdg.nix
    ]
    ++ my-modules
    ++ bundles;

  host = host;

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar --no-linenumbers";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home.file.".p10k.zsh".source = symlink "/etc/nixos/users/ironmoon/resources/.p10k.zsh";

  programs = {
    zsh = importWith ./programs/zsh.nix;
    fzf = importWith ./programs/fzf.nix;
    konsole = importWith ./programs/konsole.nix;
    okular = importWith ./programs/okular.nix;
    git = importWith ./programs/git.nix;
    firefox = importWith ./programs/firefox.nix;
    direnv = importWith ./programs/direnv.nix;

    waybar = importWith ./programs/waybar.nix;
    hyprlock = importWith ./programs/hyprlock.nix;
    kitty = importWith ./programs/kitty.nix;
    anyrun = importWith ./programs/anyrun.nix;
  };

  services = {
    dunst = importWith ./services/dunst.nix;
    hypridle = importWith ./services/hypridle.nix;
    hyprpaper = importWith ./services/hyprpaper.nix;
    hyprpolkitagent = importWith ./services/hyprpolkitagent.nix;
  };

  programs.plasma = importWith ./env/plasma.nix;
  wayland.windowManager.hyprland = importWith ./env/hyprland.nix;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
