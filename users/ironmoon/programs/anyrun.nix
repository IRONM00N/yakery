{ config, pkgs, ... }:
{
  enable = config.host.hyprland;
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

    # TODO: https://github.com/anyrun-org/anyrun/issues/211#issuecomment-2822584485
    plugins = with pkgs; [
      "${anyrun}/lib/libapplications.so"
      "${anyrun}/lib/librink.so"
      "${anyrun}/lib/libsymbols.so"
      "${anyrun}/lib/libdictionary.so"
    ];
  };

  extraCss = # css
    ''
      #window {
        background: transparent;
      }
    '';

  extraConfigFiles = {
    "dictionary.ron".text = # ron
      ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';
    "symbols.ron".text = # ron
      ''
        Config(
          prefix: ":sym",
          max_entries: 3,
          symbols: {
            "shrug": "¯\\_(ツ)_/¯",
          },
        )
      '';
  };
}
