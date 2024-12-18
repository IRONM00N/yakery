{ pkgs }:

let
  coq = pkgs.coq;
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
    with pkgs;
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

  meta = with pkgs.lib; {
    description = "Language server for the vscoq vscode/codium extension";
    homepage = "https://github.com/coq-community/vscoq";
    maintainers = with maintainers; [ cohencyril ];
    license = licenses.mit;
  };
}
