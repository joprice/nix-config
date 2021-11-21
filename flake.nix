{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "nixos.org/channels/nixpkgs-21.05-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    homeConfigurations = {
      joseph = inputs.home-manager.lib.homeManagerConfiguration {
        #system = "x86_64-linux";
        homeDirectory = "/Users/josephprice";
        username = "joseph";
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}
