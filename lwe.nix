{
  pkgs ? import <nixpkgs> {}
}:

pkgs.stdenv.mkDerivation {
  pname = "linux-wallpaperengine";
  version = "unstable-2023-09-23";

  src = pkgs.fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    # upstream lacks versioned releases
    rev = "21c38d9fd1d3d89376c870cec5c5e5dc7086bc3c";
    hash = "sha256-bZlMHlNKSydh9eGm5cFSEtv/RV9sA5ABs99uurblBZY=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];

  buildInputs = with pkgs; [
    ffmpeg
    libglut
    freeimage
    glew
    glfw
    glm
    libGL
    libpulseaudio
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    xorg.libXrandr
    xorg.libXpm
    xorg.libXxf86vm
    mpv
    lz4
    SDL2
    SDL2_mixer.all
    zlib
  ];

  meta = with pkgs; {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Only;
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
}
