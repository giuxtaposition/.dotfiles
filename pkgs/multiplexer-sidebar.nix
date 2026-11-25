{
  stdenvNoCC,
  fetchurl,
  python3,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "multiplexer-sidebar";
  version = "0.5.1";

  # A single dependency-free Python file, shipped as the release asset itself.
  src = fetchurl {
    url = "https://github.com/milanglacier/multiplexer-sidebar/releases/download/v${version}/multiplexer-sidebar";
    sha256 = "sha256-Wb9Bo09HtnW19v0CodFBPK6wuL8joMWtxVLidTHyaAQ=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  buildInputs = [python3];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/multiplexer-sidebar
    patchShebangs $out/bin/multiplexer-sidebar
    ln -s multiplexer-sidebar $out/bin/multiplexer-dashboard
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sidebar and fullscreen dashboard of tmux sessions and the coding agents in them";
    homepage = "https://github.com/milanglacier/multiplexer-sidebar";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    mainProgram = "multiplexer-sidebar";
  };
}
