# Shared system settings for this user's machines.
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Compatibility baseline for this configuration; keep it when upgrading NixOS.
  system.stateVersion = "25.05";

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

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  zramSwap.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;

  services.earlyoom.enable = true;

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        DNS = "1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net";
        FallbackDNS = "8.8.8.8#dns.google 8.8.4.4#dns.google";
        Domains = "~.";
        DNSStubListener = "yes";
        DNSSEC = "opportunistic";
        DNSOverTLS = "opportunistic";
        MulticastDNS = "true";
        LLMNR = "true";
      };
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [5353];
    };

    wireless.iwd = {
      enable = true;

      settings = {
        Settings = {
          AutoConnect = true;
        };

        Network = {
          EnableIPv6 = true;
          NameResolvingService = "systemd";
        };
      };
    };

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      wifi = {
        backend = "iwd";
        powersave = false;
      };

      plugins = with pkgs; [
        networkmanager-l2tp
      ];
    };

    dhcpcd.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

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

  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
  programs.fish.enable = true;

  programs.throne = {
    enable = true;

    tunMode = {
      enable = true;
      setuid = true;
    };
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
  documentation.man.cache.enable = false;

  environment.systemPackages = with pkgs; [
    vim
  ];

  # Fix for L2TP VPN connection
  environment.etc = {
    "strongswan.conf".text = "";
  };

  services.zapret-discord-youtube = {
    enable = false;
    configName = "general (ALT12)";

    gameFilter = "null";

    listGeneral = [];
    listExclude = [];

    ipsetAll = ["192.168.1.0/24" "10.0.0.1"];
    ipsetExclude = ["203.0.113.0/24"];
  };
}
