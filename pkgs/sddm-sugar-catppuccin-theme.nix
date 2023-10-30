{ stdenv, src, ... }:

stdenv.mkDerivation {
  name = "sddm-sugar-catppuccin-theme";
  version = "1.0.0";
  inherit src;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';
}
