{ stdenv, src, version, rustPlatform, ... }:

rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  inherit version;
  inherit src;
  cargoSha256 = "IuSHOa6loek9w9XGrtwdyMcE2N85/A5T6DNoTmRBuYc=";

  patchPhase = ''
    substituteInPlace src/lib.rs \
      --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
  '';
}
