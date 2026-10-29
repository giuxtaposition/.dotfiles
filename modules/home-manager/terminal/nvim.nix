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
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      withNodeJs = true;
      withRuby = false;
      withPython3 = false;
      sideloadInitLua = true;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = with pkgs; [imagemagick lua51Packages.luarocks];
    };

    home.packages = with pkgs; [
      lsof #needed for opencode.nvim
    ];

    xdg.configFile.nvim.source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/nvim";
  };
}
