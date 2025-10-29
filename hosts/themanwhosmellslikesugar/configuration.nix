# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.earlyoom.enable = true;
  services.scx.enable = true;

  services.resolved.enable = true;

  networking = {
    hostName = "themanwhosmellslikesugar-MG";
    firewall.enable = true;
    nameservers = ["8.8.8.8" "1.1.1.1"];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = with pkgs; [
        networkmanager-l2tp
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
  };

  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.themanwhosmellslikesugar = {
    isNormalUser = true;
    description = "themanwhosmellslikesugar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false;

  environment.systemPackages = with pkgs; [
    vim
  ];

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  # Fix for L2TP VPN connection
  environment.etc = {
    "strongswan.conf".text = "";
  };

  home-manager.backupFileExtension = "backup";

  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.themanwhosmellslikesugar =
    { ... }:
    {
      imports = [
        ./home-manager/home.nix
        inputs.plasma-manager.homeModules.plasma-manager
      ];
    };

  system.stateVersion = "25.05";
}
