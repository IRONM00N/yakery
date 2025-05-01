{ info, ... }:
let
  night-landscape = builtins.toString (
    builtins.path {
      path = ../resources/wallpapers/night-landscape.jpg;
      name = "night-landscape.jpg";
    }
  );
  boat_lake-2256x1504 = builtins.toString (
    builtins.path {
      path = ../resources/wallpapers/boat_lake-2256x1504.png;
      name = "boat_lake-2256x1504.png";
    }
  );
  used_paper = if info.id == "framework-13-7040-amd" then boat_lake-2256x1504 else night-landscape;
in
{
  enable = true;

  settings = {
    ipc = "on";

    preload = [ used_paper ];
    wallpaper = [ ", ${used_paper}" ];
  };
}
