{ config, ... }:
{
  home.file."Pictures/wallpaper.jpg".source = ./assets/wallpaper.jpg;

  programs.plasma.enable = true;
  programs.plasma.immutableByDefault = true;

  programs.plasma.input.keyboard.layouts = [
    {
      layout = "us";
    }
    {
      layout = "ru";
    }
  ];

  programs.plasma.shortcuts = {
    "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [
      "Meta+Space"
      "Meta+Alt+K"
      "Switch to Next Keyboard Layout"
    ];
  };

  programs.plasma.workspace = {
    wallpaper = "${config.home.homeDirectory}/Pictures/wallpaper.jpg";
    lookAndFeel = "org.kde.breezedark.desktop";
  };

  programs.plasma.configFile."kcminputrc" = {
    "Libinput/Defaults/Touchpad" = {
      Enabled = true;
      NaturalScroll = true;
    };
  };

  programs.plasma.kwin.nightLight = {
    enable = true;
    mode = "constant";
    temperature.night = 3900;
  };
}
