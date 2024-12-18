# based on the twitter-color-emoji package (https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/tw/twitter-color-emoji/package.nix)
# acts as a fallback for platforms that don't support COLR/CPAL
{ pkgs }:

let
  noto-fonts-color-emoji = pkgs.noto-fonts-color-emoji;
  lib = pkgs.lib;
  fetchFromGitHub = pkgs.fetchFromGitHub;
in
pkgs.stdenv.mkDerivation rec {
  pname = "twemoji-cbdt";
  version = "15.1.0";

  twemojiSrc = fetchFromGitHub {
    name = "twemoji";
    owner = "jdecked";
    repo = "twemoji";
    rev = "v${version}";
    hash = "sha256-ZhbBtmVv6WK8j+JAHYbNkL5UdH9An1Rv9Cc6ZZ4OjHI=";
  };

  srcs = [
    noto-fonts-color-emoji.src
    twemojiSrc
  ];

  sourceRoot = noto-fonts-color-emoji.src.name;

  postUnpack = ''
    chmod -R +w ${twemojiSrc.name}
    mv ${twemojiSrc.name} ${noto-fonts-color-emoji.src.name}
  '';

  nativeBuildInputs = with pkgs; [
    cairo
    imagemagick
    pkg-config
    pngquant
    (python3.withPackages (
      python-packages: with python-packages; [
        fonttools
        nototools
      ]
    ))
    which
    zopfli
  ];

  postPatch =
    let
      templateSubstitutions = lib.concatStringsSep "; " [
        "s#Noto Color Emoji#Twemoji CBDT#"
        "s#NotoColorEmoji#TwemojiCBDT#"
        ''s#Copyright .* Google Inc\.#Twitter, Inc and other contributors.#''
        "s# Version .*# ${version}#"
        "s#.*is a trademark.*##"
        ''s#Google, Inc\.#Twitter, Inc and other contributors#''
        "s#http://www.google.com/get/noto/#https://twemoji.twitter.com/#"
        "s#.*is licensed under.*#      Creative Commons Attribution 4.0 International#"
        "s#http://scripts.sil.org/OFL#http://creativecommons.org/licenses/by/4.0/#"
      ];
    in
    ''
      ${noto-fonts-color-emoji.postPatch}

      sed '${templateSubstitutions}' NotoColorEmoji.tmpl.ttx.tmpl > TwemojiCBDT.tmpl.ttx.tmpl
      pushd ${twemojiSrc.name}/assets/72x72/
      for png in *.png; do
          mv $png emoji_u''${png//-/_}
      done
      popd
    '';

  makeFlags = [
    "EMOJI=TwemojiCBDT"
    "EMOJI_SRC_DIR=${twemojiSrc.name}/assets/72x72"
    "BODY_DIMENSIONS=76x72"
    "BYPASS_SEQUENCE_CHECK=True"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm644 TwemojiCBDT.ttf $out/share/fonts/truetype/TwemojiCBDT.ttf
  '';
}
