{ pkgs, ... }:
let
  deps = (
    ps:
    with ps;
    [
      SDL2
      glfw
    ]
  );
in
{
  programs.jetbrains-toolbox = {
    enable = true;
    package = pkgs.jetbrains-toolbox.overrideAttrs.fhsWithPackages (ps: deps ps);
  };
}
