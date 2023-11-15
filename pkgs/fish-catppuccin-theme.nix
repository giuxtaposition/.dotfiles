{ stdenv, src, version, ... }:

stdenv.mkDerivation {
  name = "fish-catppuccin-theme";
  inherit version;
  inherit src;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/fish-catppuccin-theme
    cp -R ./themes/* $out/fish-catppuccin-theme
  '';
}
