{ ocamlPackages, fetchFromGitHub, lib }:
let
  opam2nix = import ./opam2nix.nix {
    ocamlPackagesOverride = ocamlPackages;
  };
  ocaml-lsp-server = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocaml-lsp";
    rev = "ff69e470f651dbcce71be218fd09eacc4d99e003";
    sha256 = "0ylzyhbg6hir347l9z3nnaapfp89jp7kyifk9xl9m3c5px78jahv";
    fetchSubmodules = true;
  };
  args = {
    ocaml = ocamlPackages.ocaml;
    selection = ./opam-selection.nix;
    src = {
      inherit ocaml-lsp-server;
    };
  };
  resolve =
    opam2nix.resolve args [
      "${ocaml-lsp-server}/ocaml-lsp-server.opam"
    ];
  selection = opam2nix.build args;
in
{
  #inherit git;
  opam2nixResolve = resolve;
  inherit (selection) ocaml-lsp-server;
}
