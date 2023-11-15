{ stdenv, src, version, ... }:

stdenv.mkDerivation {
  name = "candy-icons";
  inherit version;
  inherit src;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/candy-icons
    cp -R ./* $out/candy-icons/
  '';

  postInstall = ''
    gtk-update-icon-cache "$out/candy-icons"
  '';
}
