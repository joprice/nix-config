{ pkgs }:
with pkgs;
let
  opam2nix = import ./opam2nix.nix { };
  args = {
    #inherit ocaml;
    selection = ./opam-selection.nix;
    src = {
      home = ./.;
    };
  };
  resolve = opam2nix.resolve args [ "home.opam" ];
  selection = opam2nix.build args;
in
{
  inherit resolve;
  inherit (selection) home;
}
