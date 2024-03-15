{ config, pkgs, ... }: {
  # NEOVIM CONFIG
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    package = pkgs.neovim-nightly;
    extraPackages = with pkgs; [
      # Language servers
      unstable.vscode-langservers-extracted
      unstable.nodePackages_latest.typescript-language-server
      unstable.nodePackages_latest.svelte-language-server
      unstable.nodePackages_latest.bash-language-server
      unstable.nodePackages_latest.volar # vue language server
      unstable.emmet-ls
      unstable.lua-language-server
      unstable.marksman
      unstable.nil
      unstable.libclang
      unstable.kotlin-language-server

      # Linters and formatters
      unstable.prettierd # typescript formatter
      unstable.eslint_d # typescript linter
      unstable.stylua # lua formatter
      luajitPackages.luacheck # lua linter
      unstable.codespell # code spell
      unstable.nixfmt
      unstable.shellcheck # sh linter
      unstable.shfmt # sh formatter
      unstable.markdownlint-cli # markdown linter
      unstable.ktlint
    ];
  };

  home.file."${config.home.homeDirectory}/.dotfiles/.config/nvim/lua/giuxtaposition/config/nixosExtra.lua" =
    {
      text = ''
        vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
      '';

    };

  home.file."${config.home.homeDirectory}/.config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/nvim";
  };
}
