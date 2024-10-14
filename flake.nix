{
  description = "chakibchemso NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:chakibchemso/apple-fonts-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:omarcresp/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps/feat-nix-packaging";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      sys-config = {
        flake-dir = self;
        nix-modules = "${self}/modules/nixos";
        home-modules = "${self}/modules/home-manager";
        host = "fishbones"; # The hostname of the machine this configuration is for
        username = "chakibchemso"; # The username of the user this configuration is for
        home = home-manager.users."${sys-config.username}".home;
      };
    in
    {
      nixosConfigurations."${sys-config.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs sys-config;

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              # (import "${sys-config.home-modules}/overlays.spotx.nix") # messes up with text theme
            ];
          };
        };

        modules = [
          # CONFIGS ===============================================================================
          "${self}/hosts/${sys-config.host}/configuration.nix"
          "${self}/hosts/${sys-config.host}/hardware-configuration.nix"
          # MODULES ===============================================================================
          inputs.stylix.nixosModules.stylix
          inputs.spicetify-nix.nixosModules.default
          # SYS PKGS ==============================================================================
          (
            { ... }:
            {
              environment.systemPackages = [
                # inputs.winapps.packages.${system}.winapps
                # inputs.winapps.packages.${system}.winapps-launcher # optional
                # nixpkgs.callPackage ./lwe.nix {}
              ];
            }
          )
          # HOME MGR ==============================================================================
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs sys-config;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${sys-config.username}" = import "${self}/hosts/${sys-config.host}/home.nix";
            };
          }
          # END ===================================================================================
        ];
      };
    };
}
