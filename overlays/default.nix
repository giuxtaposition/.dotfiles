{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  modifications = _final: prev: {
    wezterm = inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;

    inherit (inputs.nixpkgs-wayland.packages.${prev.stdenv.hostPlatform.system}) wl-gammarelay-rs;

    slack = prev.slack.overrideAttrs (_oldAttrs: {
      fixupPhase = ''
        sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

        rm $out/bin/slack
        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --suffix PATH : ${prev.lib.makeBinPath [prev.pkgs.xdg-utils]} \
          --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
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
