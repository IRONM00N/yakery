{ ... }:
{
  system.nixos.tags = [ "kde" ];

  bundles.kde.enable = true;
  host.kde = true;
}
