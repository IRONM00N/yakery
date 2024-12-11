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
  ];
  shell = pkgs.zsh;

  packages =
    with pkgs;
    let
      python3 = (
        pkgs.python3.withPackages (
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

            # jd-gui
          ]
        )
      );
      vscoq = (
        let
          ocamlPackages = coq.ocamlPackages;
          fetch = pkgs.fetchurl {
            url = "https://github.com/coq-community/vscoq/releases/download/v2.2.1/vscoq-language-server-2.2.1.tar.gz";
            sha512 = "5118f26e5b687bc918de3409870464702f3fafc0c775ad5fac4835fc7954df66beaf83bc3a413476176160773215aae1d292816c49dc192c94566bba0fbe5a5b";
          };
        in
        ocamlPackages.buildDunePackage {
          pname = "vscoq-language-server";
          version = "2.2.1";
          src = fetch;
          nativeBuildInputs = [ coq ];
          buildInputs =
            [
              coq
              glib
              adwaita-icon-theme
              wrapGAppsHook3
            ]
            ++ (with ocamlPackages; [
              findlib
              lablgtk3-sourceview3
              yojson
              zarith
              ppx_inline_test
              ppx_assert
              ppx_sexp_conv
              ppx_deriving
              ppx_import
              sexplib
              ppx_yojson_conv
              lsp
              sel
              ppx_optcomp
            ]);

          meta = with lib; {
            description = "Language server for the vscoq vscode/codium extension";
            homepage = "https://github.com/coq-community/vscoq";
            maintainers = with maintainers; [ cohencyril ];
            license = licenses.mit;
          };
        }
      );
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
      racket
      nil
      (minecraft.overrideAttrs (oldAttrs: {
        meta = oldAttrs.meta // {
          broken = false;
        };
      }))
      slack

      python3
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

      jq
      pm2
      dune_3
      opam
      ripgrep-all
    ];
}
