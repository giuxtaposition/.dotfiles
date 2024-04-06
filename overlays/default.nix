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
