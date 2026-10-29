{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  niri-latest = inputs.niri.overlays.default;

  modifications = _final: prev: {
    inherit (inputs.nixpkgs-wayland.packages.${prev.stdenv.hostPlatform.system}) wl-gammarelay-rs;

    inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}) libdisplay-info_0_3;

    # fpdf2 2.8.5 in 26.05 fails test_image_with_explicit_dimensions — it
    # compares a rendered-PDF checksum that the pinned Pillow no longer
    # reproduces. Hydra does not ship it either, so paperless-ngx cannot build
    # without skipping that one test. Applied through pythonPackagesExtensions
    # because paperless builds its own python set via python3.override, which
    # discards any packageOverrides set further out.
    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (_pythonFinal: pythonPrev: {
          fpdf2 = pythonPrev.fpdf2.overridePythonAttrs (oldAttrs: {
            disabledTests = oldAttrs.disabledTests ++ ["test_image_with_explicit_dimensions"];
          });
        })
      ];

    slack = prev.slack.overrideAttrs (_oldAttrs: {
      fixupPhase = ''
        rm $out/bin/slack
        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --suffix PATH : ${prev.lib.makeBinPath [prev.pkgs.xdg-utils]} \
          --add-flags "--ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations"
      '';
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
}
