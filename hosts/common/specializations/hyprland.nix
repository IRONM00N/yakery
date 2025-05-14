{ ... }:
{
  system.nixos.tags = [ "hyprland" ];

  bundles.hyprland.enable = true;
  host.hyprland = true;
}
