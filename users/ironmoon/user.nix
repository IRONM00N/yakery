{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  isNormalUser = true;
  description = "ironmoon";
  extraGroups = [
    "networkmanager"
    "wheel"
    "libvirtd"
    "docker"
    "kvm"
    "dialout"
  ];
  shell = pkgs.zsh;

  packages =
    with pkgs;
    let
      used-python-pkgs =
        python-pkgs: with python-pkgs; [
          pandas
          matplotlib
          flask
          flask-session
          # requests

          annotated-types
          anyio
          certifi
          charset-normalizer
          distro
          h11
          httpcore
          httpx
          idna
          openai
          pydantic
          pydantic-core
          regex
          requests
          sniffio
          tiktoken
          tqdm
          typing-extensions
          urllib3
          python-dotenv

          ipykernel
          grip
          sympy
          cryptography
          bitarray
          gmpy2
          beautifulsoup4
          pyasn1

          setuptools

          # jd-gui
        ];
      vscoq = import ../../packages/vscoq-language-server/default.nix { inherit pkgs; };
    in
    [
      nix-index

      google-chrome
      firefox

      texlive.combined.scheme-full

      kdePackages.plasma-desktop
      kdePackages.kate
      kdePackages.kdenlive
      kdePackages.kcolorchooser
      kdePackages.kcalc
      kdePackages.ksystemlog
      kdePackages.ktimer
      kdePackages.kalarm
      kdePackages.kweather
      libsForQt5.kde-cli-tools
      kdePackages.plasma-firewall

      thunderbird
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      gimp
      inkscape
      krita
      # blender
      obs-studio
      vlc
      audacity
      zoom-us
      ocaml
      pkg-config
      obsidian
      krita
      aseprite
      nixfmt-rfc-style

      tor-browser-bundle-bin

      (discord.override {
        withVencord = true;
      })
      discord-ptb
      (discord-canary.override {
        withOpenASAR = true;
        withVencord = true;
      })
      (vesktop.override {
        withMiddleClickScroll = true;
        withTTS = true;
      })
      spotify

      racket
      nil
      # (minecraft.overrideAttrs (oldAttrs: {
      #   meta = oldAttrs.meta // {
      #     broken = false;
      #   };
      # }))
      prismlauncher
      slack

      (python3.withPackages (used-python-pkgs))
      # yarn-berry
      nodejs_22
      corepack_22

      vscoq
      coq

      (wordlists.override {
        lists = with pkgs; [
          rockyou
          seclists
        ];
      })

      postman
      ghidra

      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.clion

      qbittorrent

      frp # fast reverse proxy

      jq
      pm2
      dune_3
      opam
      ripgrep-all

      arduino-ide

      element-desktop

      (fontforge.override {
        withGUI = true;
      })

      (calibre.override {
        unrarSupport = true; # .cbr, .cbz
      })
      epubcheck
      direnv
      nix-direnv
      treefmt
    ];
}
