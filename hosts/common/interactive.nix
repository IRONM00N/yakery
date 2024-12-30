{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  imports = [
    ./networked.nix
  ];

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # security
  security.polkit.enable = true;
  security.polkit.debug = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # audios
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.wayland.compositor = "kwin";
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # xdg portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  # system wide environment variables
  environment.variables = {
    VISUAL = "${pkgs.vscode}/bin/code --wait --new-window";
    SUDO_EDITOR = "${pkgs.vscode}/bin/code --wait --new-window --disable-workspace-trust";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    DO_NOT_TRACK = 1;
  };

  # zsh
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

  # fonts
  fonts = {
    enableDefaultPackages = false;
    packages =
      let
        twemoji-colr = import ../../packages/twemoji-colr/package.nix { inherit pkgs; };
        twemoji-cbdt = import ../../packages/twemoji-cbdt/package.nix { inherit pkgs; };
      in
      with pkgs;
      [
        # default minus noto-fonts-color-emoji
        dejavu_fonts
        freefont_ttf
        gyre-fonts
        liberation_ttf
        unifont

        # other
        fira-code
        fira-code-symbols
        nerd-fonts.fira-code
        lato
        twemoji-colr
        twemoji-cbdt
      ];
    fontconfig.defaultFonts.emoji = [ "Twemoji COLR" ];
  };

  # services
  services.openssh.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.virt-manager.enable = true;

  # user account.
  # set a password with `passwd`
  users.users.ironmoon = import ../../users/ironmoon/user.nix {
    config = config;
    pkgs = pkgs;
    pkgs-stable = pkgs-stable;
  };

  # home-manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
    users.ironmoon = import ../../users/ironmoon/home-manager.nix;
  };

  # basic programs
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.partition-manager.enable = true;

  # generate man pages
  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
}
