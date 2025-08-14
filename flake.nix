{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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
    { nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.alejandra;

      nixosConfigurations."themanwhosmellslikesugar-MG" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./hosts/themanwhosmellslikesugar/configuration.nix
          ./hosts/themanwhosmellslikesugar/hardware-configuration.nix
          inputs.chaotic.nixosModules.default
        ];
      };

      homeConfigurations.themanwhosmellslikesugar = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit pkgs-stable;

        modules = [
          ./hosts/themanwhosmellslikesugar/home-manager/home.nix
          inputs.chaotic.nixosModules.default
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
