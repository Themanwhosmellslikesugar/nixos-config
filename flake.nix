{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    zapret-discord-youtube,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    homeModules = [
      ./general/home-manager/home.nix
      inputs.plasma-manager.homeModules.plasma-manager
    ];
    mkHost = hostModule:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./general/configuration.nix
          hostModule
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.default
          zapret-discord-youtube.nixosModules.default
          {
            home-manager = {
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [inputs.nix-index-database.homeModules.default];
              users.themanwhosmellslikesugar.imports = homeModules;
            };
          }
        ];
      };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations."themanwhosmellslikesugar-MG" = mkHost ./current;

    homeConfigurations.themanwhosmellslikesugar = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = homeModules ++ [inputs.nix-index-database.homeModules.default];

      extraSpecialArgs = {inherit inputs;};
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nil
        nixd
      ];
    };
  };
}
