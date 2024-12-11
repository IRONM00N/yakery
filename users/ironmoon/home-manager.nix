{
  inputs,
  config,
  pkgs,
  ...
}:
{
  home.file.".p10k.zsh".source = ./resources/.p10k.zsh;

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "emacs";

      shellAliases = {
        ll = "ls -l";
        nixrebuild = "sudo nixos-rebuild switch";
        nixupdate = "sudo nixos-rebuild switch --upgrade-all";
        nixedit = "sudoedit /etc/nixos/configuration.nix";
        edit = "code --wait --new-window --disable-workspace-trust";
      };
      history = {
        size = 100000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "colored-man-pages"
          "sudo"
        ];
        theme = "candy";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          {
            name = "romkatv/powerlevel10k";
            tags = [
              "as:theme"
              "depth:1"
              "if:\"((! $IS_TTY))\"" # don't enable powerlevel10k in TTY
            ];
          }
        ];
      };

      # This ensures that the Powerlevel10k instant prompt is enabled
      # it also defines the $IS_TTY variable, which is used to determine if we are in a TTY
      # so that we don't try rendering weird characters in a basic TTY terminal
      initExtraFirst = ''
        case $(tty) in
          (/dev/tty[1-9]) IS_TTY=1;;
                      (*) IS_TTY=0;;
        esac

        if ! (($IS_TTY)); then
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        fi
      '';
      initExtra = ''
        if ! (($IS_TTY)); then
          # Source the Powerlevel10k configuration if it exists
          [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
        fi
        bindkey '^H' backward-kill-word
      '';
    };

    plasma = {
      enable = true;
      configFile = {
        "spectaclerc"."General"."launchAction" = "UseLastUsedCapturemode";
        "spectaclerc"."GuiConfig"."captureMode" = 0;
      };
      kwin = {
        edgeBarrier = 0;
      };
    };

    konsole = {
      enable = true;
      defaultProfile = "Echo Chamber";
      profiles = {
        "Echo Chamber" = {
          font = {
            size = 10;
          };
          colorScheme = "Campbell";
          extraConfig = {
            "Scrolling" = {
              "HistoryMode" = "2";
            };
            "Appearance" = {
              ColorScheme = "Campbell";
              # don't use mono, otherwise icons are too small.
              Font = "FiraCode Nerd Font Ret";
              # However, this seems cause bolded text to take up too much space (unlike the mono variant)
              # this means that we need to disable bolding in the font settings
              BoldIntense = "false";
            };
            "Cursor Options" = {
              CursorShape = "1";
            };
          };
        };
      };
      customColorSchemes = {
        # ported from windows terminal
        Campbell = ./resources/Campbell.colorscheme;
      };
    };

    okular = {
      enable = true;
      general = {
        viewMode = "FacingFirstCentered";
        obeyDrm = false;
        zoomMode = "fitPage";
      };
    };

    git = {
      enable = true;
      userName = "IRONM00N";
      userEmail = "me@ironmoon.dev";
      signing = {
        signByDefault = true;
        key = null;
      };
      extraConfig =
        let
          gh-helper = {
            helper = "!${pkgs.gh}/bin/gh auth git-credential";
          };
        in
        {
          "credential \"https://github.com\"" = gh-helper;
          "credential \"https://gist.github.com\"" = gh-helper;
          "credential \"https://github.khoury.northeastern.edu\"" = gh-helper;
          "credential \"https://gist.github.khoury.northeastern.edu\"" = gh-helper;
          pull = {
            rebase = "true";
          };
          push = {
            autoSetupRemote = "true";
          };
          init = {
            defaultBranch = "master";
          };
          rebase = {
            autoStash = "true";
          };
        };
    };

    firefox = {
      enable = true;

      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxSuggest = builtins.toJSON {
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };
      };
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
