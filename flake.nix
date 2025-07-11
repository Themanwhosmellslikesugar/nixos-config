{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.alejandra;

      nixosConfigurations."themanwhosmellslikesugar-MG" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/themanwhosmellslikesugar/configuration.nix
          ./hosts/themanwhosmellslikesugar/hardware-configuration.nix
        ];
      };

      homeConfigurations.themanwhosmellslikesugar = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/themanwhosmellslikesugar/home-manager/home.nix
          inputs.plasma-manager.homeManagerModules.plasma-manager
        ];

        extraSpecialArgs = { inherit inputs; };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixd
        ];
      };
    };
}
