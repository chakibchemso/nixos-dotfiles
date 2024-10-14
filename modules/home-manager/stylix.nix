{ pkgs, ... }:
let

in
{
  stylix.targets.vscode.enable = false;
  stylix.targets.spicetify.enable = false;
  stylix.targets.rofi.enable = false;

  gtk.iconTheme = {
    package = pkgs.fluent-icon-theme;
    name = "pink";
  };
}
