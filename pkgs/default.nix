# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs }: {
  candy-icons = pkgs.callPackage ./candy-icons.nix {
    src = inputs.candy-icons;
    version = "master";
  };

  spotify-adblock = pkgs.callPackage ./spotify-adblock.nix {
    src = inputs.spotify-adblock;
    version = "v1.0.3";
  };

  myNodePackages = pkgs.callPackage ./node { };
}
