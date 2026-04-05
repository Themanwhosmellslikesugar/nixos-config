{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";

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
    { nixpkgs, zapret-discord-youtube, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.alejandra;

      nixosConfigurations."themanwhosmellslikesugar-MG" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/themanwhosmellslikesugar/configuration.nix
          ./hosts/themanwhosmellslikesugar/hardware-configuration.nix
          zapret-discord-youtube.nixosModules.default
        ];
      };

      homeConfigurations.themanwhosmellslikesugar = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/themanwhosmellslikesugar/home-manager/home.nix
          inputs.plasma-manager.homeModules.plasma-manager
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
