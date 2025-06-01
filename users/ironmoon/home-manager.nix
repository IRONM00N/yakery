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
    ./conf/theme.nix
    ./conf/xdg.nix
  ];

  host = host;

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar --no-linenumbers";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home.file.".p10k.zsh".source = symlink "${dot-root}/.p10k.zsh";

  programs = {
    zsh = importMod ./programs/zsh.nix;
    fzf = importMod ./programs/fzf.nix;
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
