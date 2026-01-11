{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  modifications = final: prev: {
    wezterm = inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;

    # make jellyfin skip-intro plugin show skip intro button
    jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
      installPhase = ''
        runHook preInstall

        # this is the important line
        sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

        mkdir -p $out/share
        cp -a dist $out/share/jellyfin-web

        runHook postInstall
      '';
    });

    wl-gammarelay-rs =
      inputs.nixpkgs-wayland.packages.${prev.stdenv.hostPlatform.system}.wl-gammarelay-rs;

    slack = prev.slack.overrideAttrs (oldAttrs: {
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
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
