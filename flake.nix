{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # Match configuration name to system hostname for automatic selection
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/vm/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };

      homeConfigurations = {
        nixos = inputs.home-manager.lib.homeManagerConfiguration {
          inherit inputs;
          configuration = ./hosts/nixos/home.nix;
        };
        vm = inputs.home-manager.lib.homeManagerConfiguration {
          inherit inputs;
          configuration = ./hosts/vm/home.nix;
        };
      };
    };
}
