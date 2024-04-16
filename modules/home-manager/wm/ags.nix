{ inputs, pkgs, lib, config, ... }: {
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  options = { ags.enable = lib.mkEnableOption "enables ags module"; };

  config = lib.mkIf config.ags.enable {
    programs.ags = {
      enable = true;

      configDir = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/ags";

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [ gtksourceview webkitgtk accountsservice ];
    };
  };
}
