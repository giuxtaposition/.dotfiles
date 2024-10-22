{ config, pkgs, lib, inputs, ... }: {
  options = { nvim.enable = lib.mkEnableOption "enables neovim module"; };

  config = lib.mkIf config.nvim.enable {
    # NEOVIM CONFIG
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      withNodeJs = true;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
    };

    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/nvim";
    };

    home.file."${config.home.homeDirectory}/.dotfiles/.config/nvim/lua/config/colors.lua" =
      {
        text = let c = config.colors;
        in ''
          return {
            fg = "${c.fg}";
            bg = "${c.bg}";
            dark_bg = "${c.dark_bg}";
            darker_bg = "${c.darker_bg}";
            selection_bg = "${c.selection_bg}";
            grey = "${c.grey}";
            green = "${c.green}";
            purple = "${c.purple}";
            dark_purple = "${c.dark_purple}";
            darker_purple = "${c.darker_purple}";
            lilac = "${c.lilac}";
            mauve = "${c.mauve}";
            sky = "${c.sky}";
            indigo = "${c.indigo}";
            orange = "${c.orange}";
            red = "${c.red}";
            yellow = "${c.yellow}";
            dark_yellow = "${c.dark_yellow}";
            pink = "${c.pink}";
          }
        '';
      };
  };
}
