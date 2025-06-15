args@{
  inputs,
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
{
  imports = [
    (import ./networked.nix args)
  ];

  bundles.fonts.enable = true;
  bundles.mullvad-vpn.enable = false;
  bundles.nvidia.enable = config.host.nvidia;

  specialisation = {
    kde.configuration = import ./specializations/kde.nix args;
    hyprland.configuration = import ./specializations/hyprland.nix args;
  };

  # SECURITY: this is fine for single user, personal systems.
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # audios
  services.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # system wide environment variables
  environment.variables = {
    DO_NOT_TRACK = 1;
  };

  # zsh
  environment.pathsToLink = [
    "/share/zsh"
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
  users.defaultUserShell = pkgs.zsh;

  # services
  services.openssh.enable = true;
  services.udisks2.enable = true; # for calibre

  # user account.
  # set a password with `passwd`
  users.users.ironmoon = import ../../users/ironmoon/user.nix args;

  # home-manager
  home-manager = {
    backupFileExtension = ".bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      # needed even when not using fill kde (konsole, dolphin, etc)
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    extraSpecialArgs = {
      inherit pkgs-stable inputs;
      inherit (config) host;
    };
    users.ironmoon = import ../../users/ironmoon/home-manager.nix;
  };

  programs = {
    firefox = import ./programs/firefox.nix;
    thunderbird = import ./programs/thunderbird.nix;
    zsh = {
      enable = true;
      enableCompletion = false; # this interacts poorly with ~/.zshrc
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    partition-manager.enable = true;
    gnome-disks.enable = true;
    ladybird.enable = true;
    dconf.enable = true;
    binary-ninja = {
      enable = true;
      package = pkgs.binary-ninja-free-wayland;
    };
  };

  # generate man pages
  # documentation.dev.enable = true;
  # documentation.man.generateCaches = true;

  environment.systemPackages = import ./pkgs/interactive.nix args;
}
