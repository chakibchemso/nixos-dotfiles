{ pkgs, sys-config, ... }:
let

in
{
  virtualisation.docker.enable = true;

  users.users."${sys-config.username}".extraGroups = [ "docker" ];

  # virtualisation.docker.daemon.settings = {
  #   data-root = "docker-data";
  # };
}
