{ lib, config, ... }:
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  defaultKeymap = "emacs";

  shellAliases = {
    ll = "ls -l";
    la = "ls -lAh";
    l = "ls -lah";
    nixos-update = "nix flake update --flake /etc/nixos";
    nixos-switch = "sudo nixos-rebuild switch --log-format internal-json -v |& nom --json";
    edit = "code --wait --new-window --disable-workspace-trust";
    diff = "diff -u";
    vim = "nvim";
    kssh = "kitten ssh";
    lg = "lazygit";
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
  initContent = lib.mkMerge [
    (lib.mkBefore ''
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
    '')
    ''
      if ! (($IS_TTY)); then
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      fi
      bindkey '^H' backward-kill-word
    ''
  ];
}
