final: prev: {
  spotify = prev.spotify.overrideAttrs (old: {
    srcs = [
      old.src
      (prev.fetchurl {
        url = "https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/1991c6eea6d5c112da57f50b565d4b2de3051ab7/spotx.sh";
        hash = "sha256-P4sCZcX4K7U/5Ha6EfqTvAMMU0ex5/3vSRLA/RfZaD0=";
      })
    ];

    nativeBuildInputs = old.nativeBuildInputs ++ [
      prev.util-linux
      prev.perl
      prev.unzip
      prev.zip
      prev.curl
    ];

    unpackPhase =
      builtins.replaceStrings
        [
          "unsquashfs \"$src\" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'"
        ]
        [
          ''
            unsquashfs "$(echo $srcs | awk '{print $1}')" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
            patchShebangs --build "$(echo $srcs | awk '{print $2}')"
          ''
        ]
        old.unpackPhase;

    installPhase =
      builtins.replaceStrings
        [
          "runHook postInstall"
        ]
        [
          ''
            bash "$(echo $srcs | awk '{print $2}')" -f -P "$out/share/spotify"
            runHook postInstall
          ''
        ]
        old.installPhase;
  });
}
