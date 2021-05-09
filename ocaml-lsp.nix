{ ocamlPackages, fetchFromGitHub, lib, stdenv, git, writeShellScriptBin }:
let
  opam2nix = (
    import ./opam2nix.nix {
      ocamlPackagesOverride = ocamlPackages;
    }
  ).overrideAttrs (
    o: {
      # see https://github.com/timbertson/opam2nix/issues/34
      buildInputs = (o.buildInputs or []) ++ [ git ];
    }
  );
  # Converted from shell
  # https://github.com/timbertson/opam2nix/blob/7ebd265ba4926062928c6b6cfece63b07ae853f4/nix/api.nix#L20
  resolve =
    { ocaml, selection, ... }: args:
      writeShellScriptBin "ocaml-lsp-resolve" ''
        ${opam2nix}/bin/opam2nix resolve \
          --dest ${builtins.toString selection} \
          --ocaml-version ${ocaml.version} \
          ${lib.concatStringsSep " " (map (arg: "'${builtins.toString arg}'") args)}
        { exit $?; } 2>/dev/null
      '';
  ocaml-lsp-server = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocaml-lsp";
    rev = "e6861a6a0bdcfd1bf597433f113cc4f7e57c8c03";
    sha256 = "0s38r20xs19h9d248km5rjsavyy46vpixm3di8p22db015k8wrgi";
    fetchSubmodules = true;
  };
  args = {
    ocaml = ocamlPackages.ocaml;
    selection = ./opam-selection.nix;
    src = {
      inherit ocaml-lsp-server;
    };
  };
  opam2nixResolve = resolve args [
    "${ocaml-lsp-server}/ocaml-lsp-server.opam"
  ];
  selection = opam2nix.build args;
in
{
  inherit opam2nixResolve;
  inherit (selection) ocaml-lsp-server;
}
