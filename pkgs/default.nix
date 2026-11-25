# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: {
  rtk = pkgs.callPackage ./rtk.nix {};
  multiplexer-sidebar = pkgs.callPackage ./multiplexer-sidebar.nix {};
}
