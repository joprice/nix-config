resolve:
	nix-shell -A resolve ./home.nix

upload-deps:
	nix-store -qR --include-outputs `nix-instantiate shell.nix` | grep -v ocaml_nix | cachix push joprice
