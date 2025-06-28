{
  pkgs,
  lib,
  ...
}: {
  imports = [ ./plasma.nix ./firefox.nix ./zed.nix ./projects.nix ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;
  home.username = "themanwhosmellslikesugar";
  home.homeDirectory = "/home/themanwhosmellslikesugar";

  home.packages = with pkgs; [
    # KDE
    kdePackages.kcalc
    kdePackages.dragon
    kdePackages.juk

    gnumake
    openvpn
    uv
    k9s
    zellij
    kubectl

    htop
    obsidian
    onlyoffice-bin
    telegram-desktop
  ];

  programs.git = {
    enable = true;
    userEmail = "tmwsls12@gmail.com";
    userName = "Dmitriy Ivanko";
    extraConfig.init.defaultBranch = "master";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_radius_v2_ed25519"
          "~/.ssh/id_rsa"
        ];
        identitiesOnly = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  home.activation.completions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/fish/completions
    ${pkgs.uv}/bin/uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish
  '';

  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
    };
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = [ "org.kde.dragon.desktop" ];
    "video/x-matroska" = [ "org.kde.dragon.desktop" ];
    "video/x-msvideo" = [ "org.kde.dragon.desktop" ];
    "video/avi" = [ "org.kde.dragon.desktop" ];
    "video/mpeg" = [ "org.kde.dragon.desktop" ];
    "video/webm" = [ "org.kde.dragon.desktop" ];
    "video/quicktime" = [ "org.kde.dragon.desktop" ];
  };
}
