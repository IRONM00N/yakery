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
    closeOnClick = true;
    showResultsImmediately = false;
    maxEntries = null;

    plugins = with inputs.anyrun.packages.${pkgs.system}; [
      applications
      rink
      dictionary
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

  extraConfigFiles = {
    "dictionary.ron".text = ''
      Config(
        prefix: ":def",
        max_entries: 5,
      )
    '';
  };
}
