{ stdenv, src, ... }:

stdenv.mkDerivation {
  name = "sddm-sugar-catppuccin-theme";
  version = "1.0.0";
  inherit src;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/sddm-sugar-catppuccin-theme
    cp -R ./* $out/sddm-sugar-catppuccin-theme/
  '';
}
