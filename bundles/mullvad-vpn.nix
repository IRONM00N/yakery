{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkIf
    mkDefault
    ;
  cfg = config.bundles.mullvad-vpn;
in
{
  options.bundles.mullvad-vpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mullvad vpn.";
    };
  };

  config = mkIf cfg.enable {
    services.resolved.enable = true;
    services.mullvad-vpn.enable = mkDefault true;
    services.mullvad-vpn.package = mkDefault pkgs.mullvad-vpn;

    environment.systemPackages = with pkgs; [
      mullvad-vpn
      mullvad
    ];
  };
}
