{ lib, config, inputs, pkgs, ... }: {

  options = { spotify.enable = lib.mkEnableOption "enables spotify module"; };

  config = lib.mkIf config.spotify.enable {
    programs.spicetify =
      let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle # shuffle+ (special characters are sanitized out of extension names)
          keyboardShortcut # vim-like keybindings
          beautifulLyrics
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
      };
  };
}
