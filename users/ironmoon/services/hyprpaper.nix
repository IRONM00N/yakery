{ ... }:
let
  night-landscape = builtins.toString (
    builtins.path {
      path = ../resources/wallpapers/night-landscape.jpg;
      name = "night-landscape.jpg";
    }
  );
in
{
  enable = true;

  settings = {
    ipc = "on";

    preload = [ night-landscape ];
    wallpaper = [ ", ${night-landscape}" ];
  };
}
