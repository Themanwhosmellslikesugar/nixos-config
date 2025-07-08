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
    "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
  };

  programs.plasma.workspace = {
    wallpaper = "${config.home.homeDirectory}/Pictures/wallpaper.jpg";
    lookAndFeel = "org.kde.breezedark.desktop";
  };

  programs.plasma.input.touchpads = [
    {
      enable = true;
      name = "GXTP7863:00 27C6:01E0 Touchpad";
      vendorId = "27c6";
      productId = "01e0";
      naturalScroll = true;
    }
  ];

  programs.plasma.kwin.nightLight = {
    enable = true;
    mode = "constant";
    temperature.night = 3900;
  };
}
