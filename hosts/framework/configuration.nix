# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  lib,
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
        lib
        pkgs
        pkgs-stable
        additional-user-pkgs
        system
        ;
    })
  ];

  host = {
    id = "framework-13-7040-amd";
    hostname = "framework";
    laptop = true;
    fingerprint = true;
  };

  bundles.ctf.enable = true;
  bundles.printing.enable = false;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      default = "saved";
      splashImage = null;
      extraEntries = ''
        menuentry "Arch Linux" --class arch --class os {
          savedefault
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root 2640-C7E0
          linux /vmlinuz-linux root=UUID=4938a3eb-6e3f-476b-9449-b20967de3d5e rw quiet
          initrd /initramfs-linux.img
        }

        menuentry "Windows" --class windows --class os {
          savedefault
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root 2640-C7E0
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  services.fwupd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    interactive-pkgs
    ++ (with pkgs; [
      fprintd
      # man-pages-posix
      powertop
    ]);

  # fingerprint reader support
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false; # waits for fingerprint otherwise

  # battery stuff
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  boot.kernelModules = [ "cpufreq_stats" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
