{ pkgs, ... }:
let

in
{
  stylix.enable = true;

  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.polarity = "dark";

  stylix.targets.plymouth.logoAnimated = false;

  stylix.cursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux"; # or "BreezeX-RosePineDawn-Linux";
    size = 24;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 10;
      terminal = 12;
      desktop = 10;
      popups = 10;
    };
  };
}
