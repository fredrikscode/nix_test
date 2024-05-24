{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
      };
    in {
      nixosConfigurations = {
        myHost = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./hosts/myHost.nix
            ./modules/common.nix
          ];
        };
      };

      homeConfigurations = {
        myUser = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./users/myUser.nix
          ];
        };
      };
    };
}