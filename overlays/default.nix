{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  niri-latest = inputs.niri.overlays.default;

  modifications = _final: prev: {
    inherit (inputs.nixpkgs-wayland.packages.${prev.stdenv.hostPlatform.system}) wl-gammarelay-rs;

    slack = prev.slack.overrideAttrs (_oldAttrs: {
      fixupPhase = ''
        rm $out/bin/slack
        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --suffix PATH : ${prev.lib.makeBinPath [prev.pkgs.xdg-utils]} \
          --add-flags "--ozone-platform=x11"
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
