{ config, pkgs, inputs, ... }:

{

  # Programs!
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports for local network game transfers
      #			package = pkgs.steam.override { extraArgs = "-system-composer"; };
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
    rsi-launcher = {
      enable = true;
      preCommands = "export MANGO_HUD=1;";
    };
    uwsm = {
      enable = true;
      #			waylandCompositors.hyprland.enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
      ];
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        				set -g fish_greeting ""
          				'';
      #        			plugins = [
      #      				{
      #      				name = "fzf-fish";
      #      				src = pkgs.fishPlugins.fzf-fish.src;
      #      				}
      #      				{
      #      				name = "done";
      #      				src = pkgs.fishPlugins.done.src;
      #      				}
      #      			];
    };


  };


  environment.systemPackages = with pkgs; [
    vim
    wget
    nano
    kitty
    rofi
    rtkit
    wireplumber # Audio control
    libgtop # System resource tracking
    bluez # Bluetooth tracking
    networkmanager # Network tracking
    brightnessctl # Screen brightness matching
    bibata-cursors
    tuigreet # Login interface helper
    hyprpaper # Wallpaper utility
    hypridle # Idle watcher daemon
    hyprlock # Screen locker program
    libappindicator-gtk3
    libappindicator-gtk2
    libappindicator
    killall
    telegram-desktop
    signal-desktop
    discord
    blueman # A lightweight graphical Bluetooth manager and system tray app
    bluez
    cabextract # Required for unpacking underlying launcher scripts safely
    mangohud
    git
    deskflow
    btop
    nvtopPackages.amd
    # 1. Screenshot and Recording Utilities
    grimblast # Capture arbitrary rectangles/windows easily
    slurp # The visual rectangle-selection tool used by grimblast
    swappy # A fantastic editing popup tool to draw arrows/text on screenshots
    wf-recorder # High-performance Wayland screen video recorder
    # 2. Clipboard History Manager
    cliphist # Clipboard history manager
    wl-clipboard # Core Wayland clipboard copy/paste tool
    pantheon.pantheon-agent-polkit
    haruna
    pavucontrol # Simple, clean UI to route individual app streams
    qjackctl # Optional: Advanced patchbay for manual line routing
    crosspipe # Pipewire patchbay front end
    go # Installs the latest stable Go compiler and tools
    gopls # Optional: Go language server for IDE features
    delve # Optional: The go debugger tool
    jetbrains.goland
    kdePackages.kate # The excellent Kate advanced text editor
    kdePackages.dolphin # The powerful companion file manager
    kdePackages.kio-extras # Crucial for Dolphin thumbnail previews & network paths
    cifs-utils
    samba
    # Secure password wallet framework for KDE apps
    kdePackages.kwallet-pam # Auto-unlocks wallet with your Linux login
    kdePackages.plasma-integration # Bridges KDE apps to non-KDE window managers
    microsoft-edge # Microsoft Edge browser (Stable)
    libreoffice-fresh # The modern, fully maintained successor to OpenOffice
    obs-studio # OBS Studio for streaming and recording
    obs-studio-plugins.obs-vkcapture
    brightnessctl # Media key hardware control
    solaar # Logitech perpheral management panel
    #		xembedsniproxy		# Let WINE systray items appear in the Wayland systray
    #		snixembed
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    libdbusmenu-gtk3 # Allows Electron/GTK apps to send system tray menu trees
    adwaita-icon-theme
    kdePackages.sddm-kcm
    kdePackages.breeze-icons
    hicolor-icon-theme
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
    gnupg
    pinentry-qt
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    jq #json query utility
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.qtsvg
    fastfetch
    libva
    mesa
    qt6Packages.qt6ct
    libnotify
    dnsutils
    nixpkgs-fmt
  ];
}
