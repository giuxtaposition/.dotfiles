# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs }: {
  candy-icons = pkgs.callPackage ./candy-icons.nix {
    src = inputs.candy-icons;
    version = "master";
  };

  myNodePackages = pkgs.callPackage ./node { };
}
