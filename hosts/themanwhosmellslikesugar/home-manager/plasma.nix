{ ... }:
{
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

  programs.plasma.workspace.lookAndFeel = "org.kde.breezedark.desktop";
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
