{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bundles.nvidia;
in
{
  options.bundles.nvidia = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA specific options.";
    };
  };

  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = mkIf info.nvidia {
      enable = true;
    };
    hardware.nvidia = mkIf info.nvidia {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      # these are not yet ready:
      open = true;
      nvidiaSettings = true; # nvidia-settings
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = mkIf info.nvidia [ "nvidia" ];
  };
}
