{ stdenv, src, version, ... }:

stdenv.mkDerivation {
  name = "bat-catppuccin-theme";
  inherit version;
  inherit src;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bat-catppuccin-theme
    cp -R ./themes/*.tmTheme $out/bat-catppuccin-theme
  '';
}
