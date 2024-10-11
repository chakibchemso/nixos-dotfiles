{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable Security Services
  users.users.root.hashedPassword = "!";
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  security.apparmor = {
    enable = true;
    packages = with pkgs; [
      apparmor-utils
      apparmor-profiles
    ];
  };
  services.fail2ban.enable = true;
  security.pam.services.hyprlock = { };
  security.polkit.enable = true;
  # programs.browserpass.enable = true;
  services.clamav = {
    daemon.enable = true;
    fangfrisch.enable = true;
    fangfrisch.interval = "daily";
    updater.enable = true;
    updater.interval = "daily"; # man systemd.time
    updater.frequency = 12;
  };
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      vesktop = {
        executable = "${lib.getBin pkgs.vesktop}/bin/vesktop";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };
      #      slack = {
      #        executable = "${lib.getBin pkgs.slack}/bin/slack";
      #        profile = "${pkgs.firejail}/etc/firejail/slack.profile";
      #      };
      #      telegram-desktop = {
      #        executable = "${lib.getBin pkgs.tdesktop}/bin/telegram-desktop";
      #        profile = "${pkgs.firejail}/etc/firejail/telegram-desktop.profile";
      #      };
      #      thunar = {
      #        executable = "${lib.getBin pkgs.xfce.thunar}/bin/thunar";
      #        profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
      #      };
      vscode = {
        executable = "${lib.getBin pkgs.vscode}/bin/code";
        profile = "${pkgs.firejail}/etc/firejail/code.profile";
      };
      zen = {
        executable = "${lib.getBin inputs.zen-browser}/bin/zen";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vulnix # scan command: vulnix --system
    clamav # scan command: sudo freshclam; clamscan [options] [file/directory/-]
    chkrootkit # scan command: sudo chkrootkit

    polkit_gnome
  ];
}
