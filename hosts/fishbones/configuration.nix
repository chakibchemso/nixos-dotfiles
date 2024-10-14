{
  inputs,
  pkgs,
  sys-config,
  ...
}:
{
  imports = [
    # "${modules-nixos}/envar.session.nix"
    "${sys-config.nix-modules}/docker.nix"
    "${sys-config.nix-modules}/gaming.nix"
    "${sys-config.nix-modules}/nix.settings.nix"
    "${sys-config.nix-modules}/services.kdeconnect.nix"
    "${sys-config.nix-modules}/services.polkit.nix"
    "${sys-config.nix-modules}/services.security.nix"
    "${sys-config.nix-modules}/stylix.nix"

    "${sys-config.home-modules}/jetbrains.nix"
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = 3;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiSupport = true;

  # Plymouth.
  boot.plymouth.enable = true;

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"

    "fbcon=nodefer"
    "vt.global_cursor_default=0"
    "kernel.modules_disabled=1"
    "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
    "usbcore.autosuspend=-1"
    "video4linux"
    "acpi_rev_override=5"
    "security=selinux"
  ];

  systemd.package = pkgs.systemd.override { withSelinux = true; };

  networking.hostName = "fishbones";

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Algiers";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.kmscon.enable = true;

  services.xserver.enable = true;
  #  services.displayManager.sddm.enable = true;
  #  services.displayManager.sddm.wayland.enable = true;
  services.greetd.enable = true;
  # services.greetd.settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
  services.greetd.settings.default_session.command = "dbus-launch Hyprland";
  services.greetd.settings.default_session.user = "${sys-config.username}";

  programs.hyprland.enable = true;

  programs.fish.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${sys-config.username}" = {
    isNormalUser = true;
    description = "Chakib Chemso";
    initialPassword = "chakibchemso";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # chromium
      inputs.zen-browser.packages."${system}".specific
      alacritty
      wget
      vesktop
      # spotify
      # spicetify-cli
      # (unityhub.override { extraLibs = { ... }: [ harfbuzz ]; })
      unityhub
      godot_4
      # vscode
      jetbrains-toolbox
      # (jetbrains.plugins.addPlugins jetbrains.rider [ "github-copilot" ])
      (jetbrains.plugins.addPlugins jetbrains.rust-rover [ "github-copilot" ])
      (jetbrains.plugins.addPlugins jetbrains.clion [ "github-copilot" ])
      (jetbrains.plugins.addPlugins jetbrains.webstorm [ "github-copilot" ])
      ani-cli
      mpv
      vlc

      # (callPackage "${sys-config.home-modules}/fdm.nix" { })

      neofetch
      htop

      xfce.thunar
      dolphin
      nautilus
      kdePackages.ark

      dotnet-sdk_8
      rustup
      # cargo
      # rustc
    ];
  };

  environment.sessionVariables = {
    ANI_CLI_PLAYER = "mpv";
  };

  documentation.man.generateCaches = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    (pkgs.writeShellScriptBin "song-status" ''
      #!/bin/bash
      player_name=$(playerctl metadata --format '{{playerName}}')
      player_status=$(playerctl status)

      if [[ "$player_status" == "Playing" ]]; then
        if [[ "$player_name" == "spotify" ]]; then
          song_info=$(playerctl metadata --format '{{title}}  󰓇   {{artist}}')
        elif [[ "$player_name" == "firefox" ]]; then
          song_info=$(playerctl metadata --format '{{title}}  󰈹   {{artist}}')
        elif [[ "$player_name" == "mpd" ]]; then
          song_info=$(playerctl metadata --format '{{title}}  󰎆   {{artist}}')
        elif [[ "$player_name" == "chromium" ]]; then
          song_info=$(playerctl metadata --format '{{title}}  󰊯   {{artist}}')
        fi
      fi

      echo "$song_info" 
    '')

    (pkgs.writeShellScriptBin "network-status" ''
      #!/bin/sh
      status="$(nmcli general status | grep -oh "\w*connect\w*")"
      if [[ "$status" == "disconnected" ]]; then
        printf "󰤮 "
      elif [[ "$status" == "connecting" ]]; then
        printf "󱍸 "
      elif [[ "$status" == "connected" ]]; then
        strength="70"
        # strength = "$(nmcli -f IN-USE,SIGNAL dev wifi | grep '*' | awk '{print $2}')"
        # strength = "$(python $HOME/.config/Scripts/wifi-conn-strength)"
        if [[ "$?" == "0" ]]; then
          if [[ "$strength" -eq "0" ]]; then
            printf "󰤯 "
          elif [[ ("$strength" -ge "0") && ("$strength" -le "25") ]]; then
            printf "󰤟 "  
          elif [[ ("$strength" -ge "25") && ("$strength" -le "50") ]]; then
            printf "󰤢 "
          elif [[ ("$strength" -ge "50") && ("$strength" -le "75") ]]; then
            printf "󰤥 "
          elif [[ ("$strength" -ge "75") && ("$strength" -le "100") ]]; then
            printf "󰤨 "
          fi
        else
          printf "󰈀 "
        fi
      fi
    '')

    (pkgs.writeShellScriptBin "battery-status" ''
      #!/bin/sh
      # status="$(acpi -b | grep -ioh "\w*charging\w*")"
      # level="$(acpi -b | grep -o -P "[0-9]+(?=%)")"
      status="$(cat /sys/class/power_supply/BAT1/status)"
      level="$(cat /sys/class/power_supply/BAT1/capacity)"
      if [[ ("$status" == "Discharging") || ("$status" == "Full") ]]; then
        if [[ "$level" -eq "0" ]]; then
          printf " "
        elif [[ ("$level" -ge "0") && ("$level" -le "25") ]]; then
          printf " "
        elif [[ ("$level" -ge "25") && ("$level" -le "50") ]]; then
          printf " "
        elif [[ ("$level" -ge "50") && ("$level" -le "75") ]]; then
          printf " "
        elif [[ ("$level" -ge "75") && ("$level" -le "100") ]]; then
          printf " "
        fi
      elif [[ "$status" == "Charging" ]]; then
        printf " "
      fi
    '')

    (pkgs.writeShellScriptBin "layout-status" ''
      #!/bin/sh
      layout="$(bat /etc/vconsole.conf | grep XKBLAYOUT | awk -F'=' '{print toupper($2)}')"
      printf "%s   " "$layout"
    '')

    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    policycoreutils
    pamixer
    pavucontrol
    playerctl

    greetd.tuigreet
    # dunst
    # waybar
    # rofi-wayland
    hyprlock
    hypridle
    hyprpaper
    hyprcursor
    hyprpicker
    mpvpaper

    slurp
    grim
    swappy

    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.lightly

    nixd
    nixfmt-rfc-style
    hyprls

    git
  ];

  # /!\ Never change, even tho i did. it was 24.05
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
