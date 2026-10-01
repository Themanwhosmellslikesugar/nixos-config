{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./disko.nix
  ];

  networking.hostName = "themanwhosmellslikesugar-MG";
}
