{ inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users."zac" = { pkgs, ... }: {
      home.stateVersion = "25.05"; # match your nixpkgs channel generation, don't bump casually

      imports = [
        inputs.nix-doom-emacs-unstraightened.hmModule
      ];

      programs.doom-emacs = {
        enable = true;
        doomDir = ./doom.d; # your Doom config lives in ./doom.d in this repo
      };

      # home-manager manages its own dotfiles cleanly; this lets it self-update
      programs.home-manager.enable = true;
    };
  };
}
