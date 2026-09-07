{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "typescript7";
  version = "7.0.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@typescript/typescript-linux-x64/-/typescript-linux-x64-${version}.tgz";
    hash = "sha256-fsrW9nN36DGFY2erBi7zlPIVBqYRQFv4rA/wOTSGN9M=";
  };

  sourceRoot = "package";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/typescript $out/bin
    cp -r lib/. $out/share/typescript/
    chmod +x $out/share/typescript/tsc
    ln -s ../share/typescript/tsc $out/bin/tsc
    runHook postInstall
  '';

  meta = with lib; {
    description = "TypeScript 7 (native Go implementation) — compiler and LSP";
    homepage = "https://www.typescriptlang.org";
    license = licenses.asl20;
    platforms = ["x86_64-linux"];
    mainProgram = "tsc";
  };
}
