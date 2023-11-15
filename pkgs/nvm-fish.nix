{ stdenv, src, version, ... }:

stdenv.mkDerivation {
  name = "nvm-fish";
  inherit version;
  inherit src;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/nvm-fish
    cp -R ./* $out/nvm-fish
  '';
}
