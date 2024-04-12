{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    wezterm = inputs.nekowinston-nur.packages.${prev.system}.wezterm-nightly;
    eww = inputs.nixpkgs-wayland.packages.${prev.system}.eww;

    spotify = prev.spotify.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        ln -s ${final.spotify-adblock.out}/lib/libspotifyadblock.so $libdir
        sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
        wrapProgram $out/bin/spotify \
        --set LD_PRELOAD "${final.spotify-adblock}/lib/libspotifyadblock.so"
      '';
    });

    slack = prev.slack.overrideAttrs (oldAttrs: {
      fixupPhase = ''
        sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

        rm $out/bin/slack
        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --suffix PATH : ${prev.lib.makeBinPath [ prev.pkgs.xdg-utils ]} \
          --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
      '';
    });

  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
