{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rtk";
  version = "0.45.0";

  src = fetchurl {
    url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "sha256-xMA2+/GB/FXvMpeGyMF+DUJ5crBTuCWUTZaKaq/vG6Q=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 rtk $out/bin/rtk
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI proxy that compresses shell output before it reaches an LLM";
    homepage = "https://github.com/rtk-ai/rtk";
    license = licenses.asl20;
    platforms = ["x86_64-linux"];
    mainProgram = "rtk";
  };
}
