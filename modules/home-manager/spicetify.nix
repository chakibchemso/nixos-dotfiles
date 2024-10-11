{ inputs, pkgs, ... }:
let

in
{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      themes = pkgs.fetchFromGitHub {
        owner = "spicetify";
        repo = "spicetify-themes";
        rev = "11e89d411ba1cc77ef89ccf65f301302c3c3d566"; # letest text changes
        sha256 = "sha256-a3tGk30V+O4qOzhQ0dfucLTxFWLcAJYYigFzQVhSgiE=";
      };
    in
    {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
      enabledExtensions = with spicePkgs.extensions; [
        beautifulLyrics
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      colorScheme = "CatppuccinMocha";
      theme = {
        name = "text";
        src = "${themes}/text";
        patches = {
          "xpui.js_find_8008" = ",(\\w+=)56";
          "xpui.js_repl_8008" = ",\${1}32";
        };
        additionalCss = ''
          /* user settings */
          :root {
              --font-family: "DM Mono", monospace;
              --font-size: 14px;
              --font-weight: 400; /* 200 : 900 */
              --line-height: 1.2;

              --font-size-lyrics: 14px; /* 1.5em (default) */

              --font-family-header: "asciid";
              --font-size-multiplier-header: 4;

              --display-card-image: block; /* none | block */
              --display-coverart-image: none; /* none | block */
              --display-header-image: block; /* none | block */
              --display-library-image: block; /* none | block */
              --display-tracklist-image: none; /* none | block */
              --display-spicetify-banner-ascii: none; /* none | block */
              --display-music-banner-ascii: none; /* none | block */

              --border-radius: 10px;
              --border-width: 2px;
              --border-style: solid; /* dotted | dashed | solid | double | groove | ridge | inset | outset */
          }
        '';
      };
    };
}
