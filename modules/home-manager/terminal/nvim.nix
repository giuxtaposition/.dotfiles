{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {nvim.enable = lib.mkEnableOption "enables neovim module";};

  config = lib.mkIf config.nvim.enable {
    # NEOVIM CONFIG
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      withNodeJs = true;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = with pkgs; [imagemagick lua51Packages.luarocks];
    };

    home.packages = with pkgs; [
      lsof #needed for opencode.nvim
    ];

    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/nvim";
    };
  };
}
