{
  config,
  pkgs,
  ...
}:
let
  scarlet_tree = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/contents/images_dark/5120x2880.png";
in
{
  enable = true;
  configFile = {
    "spectaclerc"."General"."launchAction" = "UseLastUsedCapturemode";
    "spectaclerc"."GuiConfig"."captureMode" = 0;
    "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "MNS";
  };
  kwin = {
    edgeBarrier = 0;
    virtualDesktops = {
      number = 9;
      rows = 3;
    };
  };
  workspace.wallpaper = scarlet_tree;
  kscreenlocker.appearance.wallpaper = scarlet_tree;
  # panels = [
  #   {
  #     alignment = "bottom";
  #   }
  # ];
}
