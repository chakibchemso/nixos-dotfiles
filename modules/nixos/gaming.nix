{ pkgs, ... }:
let

in
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    lutris
    heroic
    bottles
    protonup
    libvirt
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "~/.steam/root/compatibilitytools.d";
  };
}
