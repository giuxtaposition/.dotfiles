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
      extraPackages = with pkgs; [
        #Programming
        go
        unstable.rustc
        cargo
        cmake
        gnumake
        tree-sitter
        nodejs_20

        # Language servers
        unstable.vscode-langservers-extracted
        unstable.nodePackages_latest.typescript-language-server
        unstable.nodePackages_latest.svelte-language-server
        unstable.nodePackages_latest.bash-language-server
        nodePackages_latest.volar # vue language server
        unstable.emmet-ls
        unstable.lua-language-server
        unstable.marksman
        unstable.nil
        unstable.libclang
        unstable.kotlin-language-server
        unstable.gopls

        # Linters and formatters
        unstable.prettierd # typescript formatter
        unstable.eslint_d # typescript linter
        unstable.stylua # lua formatter
        luajitPackages.luacheck # lua linter
        unstable.codespell # code spell
        unstable.nixfmt-classic
        unstable.shellcheck # sh linter
        unstable.shfmt # sh formatter
        unstable.markdownlint-cli # markdown linter
        unstable.ktlint
        unstable.gotools
      ];
    };

    home.packages = with pkgs; [ myNodePackages."@vtsls/language-server" ];

    home.file."${config.home.homeDirectory}/.dotfiles/.config/nvim/lua/config/nixosExtra.lua" =
      {
        text = ''
          vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
        '';

      };

    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/nvim";
    };
  };
}
