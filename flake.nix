{
  description = "Home Manager configuration of josephp";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    #nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        neovim-flake.follows = "neovim";
      };
    };
    neovim = {
      url = "github:neovim/neovim/nightly?dir=contrib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    #https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, neovim, neovim-nightly-overlay, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
        # neovim.overlay
        neovim-nightly-overlay.overlay
        # (final: prev: {
        #   inherit (neovim.packages.${prev.system}) neovim;
        # })
      ];
    in
    {
      homeConfigurations."josephp" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
