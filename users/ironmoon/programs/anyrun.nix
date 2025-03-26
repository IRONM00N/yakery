{ inputs, pkgs, ... }:
{
  enable = true;
  config = {
    x = {
      fraction = 0.5;
    };
    y = {
      absolute = 0;
    };
    width = {
      fraction = 0.3;
    };
    height = {
      absolute = 0;
    };
    hideIcons = false;
    ignoreExclusiveZones = false;
    layer = "top";
    hidePluginInfo = false;
    closeOnClick = false;
    showResultsImmediately = false;
    maxEntries = null;

    plugins = [
      inputs.anyrun.packages.${pkgs.system}.applications
      inputs.anyrun.packages.${pkgs.system}.rink
    ];
  };

  # Inline comments are supported for language injection into
  # multi-line strings with Treesitter! (Depends on your editor)
  extraCss = # css
    ''
      #window {
        background: transparent;
      }
    '';

  extraConfigFiles."some-plugin.ron".text = ''
    Config(
      // for any other plugin
      // this file will be put in ~/.config/anyrun/some-plugin.ron
      // refer to docs of xdg.configFile for available options
    )
  '';
}
