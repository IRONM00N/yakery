{
  pkgs,
  additional-pkgs,
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
    "input"
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

          pwntools

          pytest

          # jd-gui # removed
        ];
    in
    [
      nix-index
      home-manager

      networkmanagerapplet
      nwg-displays

      kdePackages.plasma-desktop
      kdePackages.kate
      kdePackages.kdenlive
      kdePackages.kcolorchooser
      kdePackages.kcalc
      kdePackages.ksystemlog
      kdePackages.ktimer
      kdePackages.kalarm
      kdePackages.kweather
      kdePackages.kwallet-pam
      kdePackages.plasma-firewall
      libsForQt5.kde-cli-tools

      google-chrome
      # firefox enabled with home-manager
      firefox-devedition-bin # devedition keeps updating and is slow
      tor-browser-bundle-bin
      element-desktop
      ladybird

      thunderbird
      birdtray
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
      pkg-config
      obsidian
      krita
      aseprite

      # https://github.com/ibraheemdev/modern-unix
      lazygit
      mcfly
      fzf
      broot
      duf
      dust
      bat
      bottom
      procs
      doggo
      glances
      gtop
      jq

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
      slack
      signal-desktop

      spotify

      (python3.withPackages (used-python-pkgs))
      # yarn-berry
      nodejs_22
      corepack_22
      pm2
      ocaml
      ocamlPackages.utop
      dune_3
      opam
      ghc
      racket
      nil
      nixfmt-rfc-style
      texlive.combined.scheme-full
      arduino-ide
      direnv
      nix-direnv
      treefmt

      pandoc

      (wordlists.override {
        lists = with pkgs; [
          rockyou
          seclists
        ];
      })

      postman
      ghidra
      burpsuite
      metasploit
      ida-free

      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.clion

      code-cursor

      qbittorrent

      frp # fast reverse proxy
      ripgrep-all

      (fontforge.override {
        withGUI = true;
      })

      (calibre.override {
        unrarSupport = true; # .cbr, .cbz
      })
      epubcheck

      # (minecraft.overrideAttrs (oldAttrs: {
      #   meta = oldAttrs.meta // {
      #     broken = false;
      #   };
      # }))
      prismlauncher
      minecraft-server

      bytecode-viewer
      jdk
      jdk11
      jdk17
      avogadro2
      openbabel
    ]
    ++ additional-pkgs;
}
