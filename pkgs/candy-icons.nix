{ stdenv, src, version, ... }:

stdenv.mkDerivation {
  name = "candy-icons";
  inherit version;
  inherit src;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';

  postInstall = ''
    gtk-update-icon-cache "$out"
  '';
}
