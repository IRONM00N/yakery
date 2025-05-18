{
  inputs,
  config,
  lib,
  pkgs,
  pkgs-stable,
  additional-user-pkgs,
  system,
  ...
}:
let
  args = {
    inherit
      inputs
      config
      lib
      pkgs
      pkgs-stable
      system
      ;
  };
  importWith = path: import path args;
in
{
  imports = [
    ./networked.nix
  ];

  bundles.fonts.enable = true;
  bundles.mullvad-vpn.enable = false;
  bundles.nvidia.enable = config.host.nvidia;

  specialisation = {
    kde.configuration = importWith ./specializations/kde.nix;
    hyprland.configuration = importWith ./specializations/hyprland.nix;
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

  # virtualization
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # user account.
  # set a password with `passwd`
  users.users.ironmoon = import ../../users/ironmoon/user.nix (
    {
      additional-pkgs = additional-user-pkgs;
    }
    // args
  );

  # home-manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      # needed even when not using fill kde (konsole, dolphin, etc)
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    extraSpecialArgs = {
      inherit pkgs-stable inputs;
      host = config.host;
    };
    users.ironmoon = import ../../users/ironmoon/home-manager.nix;
  };

  programs = {
    firefox = importWith ./programs/firefox.nix;
    thunderbird = importWith ./programs/thunderbird.nix;
    zsh.enable = true;
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
}
