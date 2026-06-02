{
  description = "NixOS system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-citizen.url = "github:LovingMelody/nix-citizen";

    # Patched Hyprland + patched XDPH
    hyprland-patched.url = "github:3l0w/Hyprland/feat/input-capture-impl";
    xdph-patched.url = "github:3l0w/xdg-desktop-portal-hyprland/feat/input-capture-impl";
  };

  outputs = { self, nixpkgs, zen-browser, nix-citizen, hyprland-patched, xdph-patched, ... } @ inputs: {
    nixosConfigurations.Goliath = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        nix-citizen.nixosModules.default

({ pkgs, ... }: {
  nixpkgs.overlays = [
    # 1. Full Hyprland ecosystem override
    (final: prev: let
      system   = pkgs.stdenv.hostPlatform.system;
      hyprPkgs = hyprland-patched.packages.${system};
    in {
      hyprland       = hyprPkgs.hyprland;
      hyprutils      = hyprPkgs.hyprutils or prev.hyprutils;
      hyprlang       = hyprPkgs.hyprlang or prev.hyprlang;
      hyprcursor     = hyprPkgs.hyprcursor or prev.hyprcursor;
      hyprgraphics   = hyprPkgs.hyprgraphics or prev.hyprgraphics;
      aquamarine     = hyprPkgs.aquamarine or prev.aquamarine;

      # base patched portal
      xdg-desktop-portal-hyprland =
        xdph-patched.packages.${system}.xdg-desktop-portal-hyprland;
    })

    # 2. (Optional) Waybar rebuild against patched libs/portal
    (final: prev: {
      waybar = prev.waybar.overrideAttrs (old: {
        buildInputs = (old.buildInputs or []) ++ [
          final.xdg-desktop-portal-hyprland
          final.hyprutils
          final.hyprlang
          final.hyprgraphics
        ];
      });
    })
  ];
})
      ];
    };
  };
}
