# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs }: {
  candy-icons = pkgs.callPackage ./candy-icons.nix {
    src = inputs.candy-icons;
    version = "master";
  };

  nvm-fish = pkgs.callPackage ./nvm-fish.nix {
    src = inputs.nvm-fish;
    version = "2.2.13";
  };

  fish-catppuccin-theme = pkgs.callPackage ./fish-catppuccin-theme.nix {
    src = inputs.fish-catppuccin-theme;
    version = "main";
  };

  spotify-adblock = pkgs.callPackage ./spotify-adblock.nix {
    src = inputs.spotify-adblock;
    version = "v1.0.3";
  };
}
