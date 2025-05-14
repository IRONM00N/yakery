{
  inputs,
  config,
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

  # security
  security.polkit.enable = true;
  # security.polkit.debug = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # audios
  services.pulseaudio.enable = pkgs.lib.mkDefault false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = pkgs.lib.mkDefault true;
    alsa.enable = pkgs.lib.mkDefault true;
    alsa.support32Bit = pkgs.lib.mkDefault true;
    pulse.enable = pkgs.lib.mkDefault true;
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # system wide environment variables
  environment.variables = {
    VISUAL = "${pkgs.vscode}/bin/code --wait --new-window";
    SUDO_EDITOR = "${pkgs.vscode}/bin/code --wait --new-window --disable-workspace-trust";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.udisks2.enable = true; # for calibre

  # virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
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
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    extraSpecialArgs = {
      inherit pkgs-stable inputs;
      host = config.host;
    };
    users.ironmoon = import ../../users/ironmoon/home-manager.nix;
  };

  programs = {
    firefox = import ./programs/firefox.nix { inherit pkgs; };
    thunderbird = import ./programs/thunderbird.nix { inherit pkgs; };
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
