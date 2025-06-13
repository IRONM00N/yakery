{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption optionalString types;

  cfg = config.programs.zsh.my-zplug;

  pluginModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the plugin.";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "The plugin tags.";
      };
    };
  };
in
{
  options.programs.zsh.my-zplug = {
    enable = lib.mkEnableOption "zplug - a zsh plugin manager";

    plugins = mkOption {
      default = [ ];
      type = types.listOf pluginModule;
      description = "List of zplug plugins.";
    };

    zplugHome = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.zplug";
      defaultText = "~/.zplug";
      apply = toString;
      description = "Path to zplug home directory.";
    };

    package = mkOption {
      default = pkgs.zplug;
      type = types.package;
      description = "The zplug package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.zsh.initContent = lib.mkOrder 550 ''
      export ZPLUG_HOME=${cfg.zplugHome}

      source ${cfg.package}/share/zplug/init.zsh

      ${optionalString (cfg.plugins != [ ]) (
        lib.concatStrings (
          map (plugin: ''
            zplug "${plugin.name}"${
              optionalString (plugin.tags != [ ]) (lib.concatStrings (map (tag: ", ${tag}") plugin.tags))
            }
          '') cfg.plugins
        )
      )}
      if ! zplug check; then
        zplug install
      fi

      zplug load
    '';

  };
}
