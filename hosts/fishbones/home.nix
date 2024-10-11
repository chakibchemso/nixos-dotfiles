{
  pkgs,
  sys-config,
  inputs,
  ...
}:

{
  home.username = sys-config.username;
  home.homeDirectory = "/home/${sys-config.username}";

  # Do not touch, for backwards compatibility
  # has nothing to do with updates
  home.stateVersion = "24.05";

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    "${sys-config.home-modules}/stylix.nix"
    "${sys-config.home-modules}/spicetify.nix"
    # "${sys-config.home-modules}/vscode.nix"
    # "${sys-config.home-modules}/jbtoolbox.nix"
  ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    # configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ".config/rofi/base16-rofi/themes/base16-catppuccin-mocha.rasi";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = [ ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
