{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  additional-user-pkgs,
  ...
}:
{
  imports = [
    ./networked.nix
  ];

  services.resolved.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # SECURITY: this is fine for single user, personal systems.
  nix.settings.trusted-users = [
    "root"
    "@wheel"
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
  services.pulseaudio.enable = pkgs.lib.mkDefault false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = pkgs.lib.mkDefault true;
    alsa.enable = pkgs.lib.mkDefault true;
    alsa.support32Bit = pkgs.lib.mkDefault true;
    pulse.enable = pkgs.lib.mkDefault true;
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
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
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
        open-sans
        # twemoji-colr
        twemoji-cbdt
      ];
    fontconfig.defaultFonts.emoji = [ "Twemoji COLR" ];
    # fontconfig.localConf = ''
    #   <?xml version="1.0"?>
    #   <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    #   <fontconfig>
    #     <alias binding="same">
    #       <family>Twemoji Color CBDT</family>
    #       <default><family>emoji</family></default>
    #     </alias>
    #     <alias binding="same">
    #       <family>emoji</family>
    #       <prefer>
    #         <family>Twemoji Color COLR</family>
    #         <family>Twemoji Color CBDT</family>
    #       </prefer>
    #     </alias>
    #   </fontconfig>
    # '';
  };

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
  users.users.ironmoon = import ../../users/ironmoon/user.nix {
    config = config;
    pkgs = pkgs;
    pkgs-stable = pkgs-stable;
    additional-pkgs = additional-user-pkgs;
  };

  # home-manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
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
  };

  # generate man pages
  # documentation.dev.enable = true;
  # documentation.man.generateCaches = true;
}
