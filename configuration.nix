# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/networking.nix
      ./modules/packages.nix
      ./modules/audio.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #Fix for networking not being available in the rebuild sandbox.
  nix.settings.extra-sandbox-paths = [
    "/etc/resolv.conf"
  ];



  # 1. Enable Hardware Bluetooth Support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Automatically power up the controller when your computer boots
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Standard multimedia routing profiles
        Experimental = true; # Shows battery percentages of connected headsets
      };
    };
  };
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  #hardware.opengl.enable = true;
  hardware.graphics = {
    extraPackages = with pkgs; [
      libva # Video Acceleration API
      mesa # Mesa drivers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      mesa
    ];
    enable = true;
    enable32Bit = true;
  };

  services.flatpak.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  services.displayManager.plasma-login-manager.settings.Users.RememberLastSession = true;
  services.desktopManager.plasma6.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };


  services.dbus = {
    enable = true;
    packages = with pkgs; [
      libdbusmenu-gtk3
      libappindicator-gtk3
    ];
  };

  services.upower.enable = true;

  # 2. Grant PAM permissions to allow hyprlock to verify your password
  security.pam.services.hyprlock = { };
  security.polkit.enable = true;
  #  security.pam.services.sddm.enable = true;
  #  security.hideProcessInformation = false;
  security.pam.services.hyprland.enableKwallet = true;
  #  security.pam.services.greetd.enableKwallet = true;
  security.pam.services.plasma-login-manager.enableKwallet = true;
  systemd.user.services.kwalletd5.enable = false;
  systemd.services."rtkit-daemon".enable = true;
  # persistently disable the GTK portal activation
  systemd.user.services."xdg-desktop-portal-gtk.service".enable = false;

  systemd.user.services."xdg-desktop-portal-kwallet.service".enable = false;








  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system}.linuxPackages-cachyos-latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."zac" = {
    isNormalUser = true;
    description = "Zac Crawforth";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Speed configurations for heavy source compilation
    max-jobs = "auto"; # Allows Nix to run multiple builds at the same time
    cores = 0; # Tells Nix to use EVERY available CPU core for each build
    trusted-users = [ "root" "zac" ];
    # Our previous binary cache addition
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];


    #    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    #			    "cachyos-kernel.cachix.org-1:Qm3d6Y0V8q7yqQ0p8Y0p8Y0p8Y0p8Y0p8Y0p8Y0p8Y0="
    #    ];
  };



  xdg.portal = {
    enable = true;
    config.hyprland = {
      default = [ "hyprland" "kde" "gtk" ];
     "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
     "org.freedesktop.impl.portal.RemoteDesktop" = [ "hyprland" ]; # Crucial for Deskflow
     extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk  # only if you actually need GTK portal
        ];
    };
  };

  # Modern NixOS Font Configuration
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code # High quality mono font with icons
    nerd-fonts.symbols-only # Highly recommended fallback for custom status bar icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  environment.sessionVariables = {
    # Match this exactly to the folder name provided by the package
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    #QT_QPA_PLATFORMTHEME = "kde";
    #QT_QPA_PLATFORMTHEME = "qt6ct";
    # Force GTK3/GTK4 apps (like Edge and OBS) into dark mode
    GTK_THEME = "Adwaita-dark";

    # Tells system portals and web-engines to prefer native dark layouts
    GTK_USE_PORTAL = "1";
    AMD_VULKAN_ICD = "RADV";

    # Forces Steam to use the absolute native Mesa RADV loader directly
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

    # Completely disables third-party layers (like MangoHud, OBS capture layers, or global overlays) 
    # that frequently cause context losses during a game's initial rendering hook
    DISABLE_VULKAN_IMPLICIT_LAYERS = "1";
  };

  # Natively expose standard schemas and portal paths across all system users
  environment.pathsToLink = [
    "/share/gsettings-desktop-schemas"
    "/share/xdg-desktop-portal"
  ];

  # Ensure environment variables for desktop applications are set
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # Enable GVfs (Virtual File System) to allow userspace mounting
  services.gvfs.enable = true;
  security.rtkit.enable = true; # no idea why this was causing issues at bootup.  Why does the desktop portal need that?
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216; # Massive buffer required for Star Citizen entities
    "fs.file-max" = 524288;
    "kernel.yama.ptrace_scope" = 0;
  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
