# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

  hardware.opengl.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.drivers # Forces clean, native 64-bit RADV paths
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa.drivers # Forces clean, native 32-bit RADV paths
    ];
  };


  # Enable the SDDM display manager with native Wayland support
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true; # Ensures the login screen itself runs on a crisp Wayland backend
  #  enableHidpi = true;
  #  theme = "breeze";
  #  package = pkgs.kdePackages.sddm;
  #};

services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop'  --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'";
      user = "greeter";
    };
  };
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
  security.pam.services.hyprlock = {};
  security.polkit.enable = true;
#  security.pam.services.sddm.enable = true;
#  security.hideProcessInformation = false;
  security.pam.services.hyprland.enableKwallet = true;
  security.pam.services.greetd.enableKwallet = true;
  systemd.user.services.kwalletd5.enable = false;
  systemd.services."rtkit-daemon".enable = true;  
# persistently disable the GTK portal activation
  systemd.user.services."xdg-desktop-portal-gtk.service".enable = false;

  systemd.user.services."xdg-desktop-portal-kwallet.service".enable = false;




services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;

  wireplumber = {
    enable = true;

    extraConfig = {
      "10-restore" = {
        "wireplumber.settings" = {
          "restore-state" = true;
        };
      };
    };
  };
};


  boot.kernel.sysctl = {
    "kernel.yama.ptrace_scope" = 0;
  };
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system}.linuxPackages-cachyos-latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."zac" = {
    isNormalUser = true;
    description = "Zac Crawforth";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Speed configurations for heavy source compilation
    max-jobs = "auto";  # Allows Nix to run multiple builds at the same time
    cores = 0;          # Tells Nix to use EVERY available CPU core for each build
    trusted-users = [ "root" "zac" ];
    # Our previous binary cache addition
    substituters = [ "https://cache.nixos.org"
		     "https://hyprland.cachix.org"
                     "https://cachix.org"
                     "https://nix-cachyos-kernel.cachix.org"
                     ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                            "nix-cachyos-kernel.cachix.org-1:b37NcwW84Oi9Yp0iigQX9ZfSscZ997R6p9SgAs9of7M="
    ];
  };



# xdg.portal: prefer hyprland, avoid extraPortals merging
xdg.portal = {
  enable = true;
  config.common.default = [ "hyprland" ];
  # extraPortals =  [ pkgs.xdg-desktop-portal-hyprland ];
};



#xdg.portal = {
#  enable = true;
#  extraPortals = with pkgs; [
#    xdg-desktop-portal-gtk
#  ];
#  config = {
#    common = {
#      default = [ "hyprland" "gtk" ];
#    };
#  };
#};

  # Modern NixOS Font Configuration
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code      # High quality mono font with icons
    nerd-fonts.symbols-only   # Highly recommended fallback for custom status bar icons
  ];

  environment.sessionVariables = {
    # Match this exactly to the folder name provided by the package
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "kde";

    # Force GTK3/GTK4 apps (like Edge and OBS) into dark mode
    GTK_THEME = "Adwaita-dark";

    # Tells system portals and web-engines to prefer native dark layouts
    GTK_USE_PORTAL = "1";
    AMD_VULKAN_ICD = "RADV";
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
