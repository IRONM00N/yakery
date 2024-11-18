# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  ...
}:
let
  interactive-pkgs = import ../common/pkgs/interactive.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../common/interactive.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      default = "saved";
      extraEntries = ''
        menuentry 'Arch Linux' --class arch --class os {
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root 2640-C7E0
          linux /vmlinuz-linux root=UUID=ed68d7da-46d7-455b-a3a7-16b610e69aa6 rw quiet
          initrd /initramfs-linux.img
        }

        menuentry 'Windows' --class windows --class os' {
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root 2640-C7E0
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  networking.hostName = "framework";
  services.printing.enable = false; # enable if need to print

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    interactive-pkgs
    ++ (with pkgs; [
      fprintd
      # man-pages-posix
    ]);

  # WARNING nix-ld: this should only be used for hacky situations such as CTFs
  # otherwise this negates the benefits of nix
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages

      glib
      nss
      nspr
      dbus
      atk
      # atk-bridge
      at-spi2-atk
      cups
      libdrm
      gtk3
      pango
      cairo
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      # gbm
      mesa
      expat
      xorg.libxcb
      libxkbcommon
      alsa-lib
      # at-spi2-core

      kdePackages.full
    ];
  };

  # fingerprint reader support
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false; # waits for fingerprint otherwise

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
