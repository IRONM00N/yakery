{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bundles.printing;
in
{
  options.bundles.printing = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable printing.";
    };
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
