# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  system,
  ...
}:
let
  additional-user-pkgs = import ./additional-user-pkgs.nix { inherit config pkgs; };
  interactive-pkgs = import ../common/pkgs/interactive.nix { inherit config pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    (import ../common/interactive.nix {
      inherit
        inputs
        config
        pkgs
        pkgs-stable
        additional-user-pkgs
        system
        ;
    })
  ];

  host = {
    id = "desktop-2070super"; # TODO: get better id
    hostname = "desktop";
    nvidia = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 2;

  environment.systemPackages =
    interactive-pkgs
    ++ (with pkgs; [
      autossh
    ]);

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    package = pkgs.papermc;
    declarative = true;
    serverProperties = {
      difficulty = 3;
      motd = "ironmoon's server";
      max-players = 21;
      view-distance = 16;
      enable-command-block = true;
    };
  };

  # SSH
  # services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      UsePAM = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "ironmoon" ];
      PermitRootLogin = "no";
    };
  };
  services.autossh.sessions = [
    {
      name = "security-nightmare";
      user = "ironmoon";
      extraArguments = "-M 0 -N -R 6922:localhost:22 ironmoon@ssh.ironmoon.dev";
    }
  ];

  # services.pulseaudio.enable = true;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = false;
  #   alsa.enable = false;
  #   alsa.support32Bit = false;
  #   pulse.enable = false;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
