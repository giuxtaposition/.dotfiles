{ lib, config, pkgs, ... }:
let
  firefoxWorkScript = pkgs.writeScriptBin "firefoxWork" ''
    #! ${pkgs.bash}/bin/sh
    firefox -P "work"
  '';

  firefoxWork = pkgs.makeDesktopItem {
    name = "firefox-work-profile";
    desktopName = "Firefox Work Profile";
    exec = ''firefox -P "work"'';
    terminal = false;
    icon = "firefox";
  };
in {
  options = { coding.enable = lib.mkEnableOption "enables coding module"; };

  config = lib.mkIf config.coding.enable {
    home.sessionVariables = {
      MONGOMS_DISTRO =
        "ubuntu-22.04"; # MONGO MEMORY SERVER not supporting nixos
      CYPRESS_INSTALL_BINARY = "0";
      CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress";
    };

    nvim.enable = true;
    bat.enable = true;
    fish.enable = true;
    git.enable = true;
    wezterm.enable = true;

    home.packages = with pkgs; [
      chromium
      (firefoxWork)
      (firefoxWorkScript)

      # Typescript/Javascript
      nodejs_22
      nodePackages_latest.pnpm
      cypress
      vscode-langservers-extracted
      nodePackages_latest.typescript-language-server
      nodePackages_latest.svelte-language-server
      vscode-extensions.vue.volar # vue language server
      emmet-ls
      prettierd # typescript formatter
      eslint_d # typescript linter
      myNodePackages."@vtsls/language-server"

      # Lua
      lua-language-server
      stylua # lua formatter
      luajitPackages.luacheck # lua linter

      # Nix
      nil
      nixfmt-classic

      # Kotlin
      kotlin
      kotlin-language-server
      gradle
      jdk
      ktlint

      # Rust
      rustc
      cargo

      # Go
      go
      gopls
      gotools

      # Bash/Sh
      nodePackages_latest.bash-language-server
      shellcheck # sh linter
      shfmt # sh formatter

      # C/C++
      libclang
      cmake

      # Markdown
      marksman
      markdownlint-cli # markdown linter

      # DBs
      mongodb-compass
      sqlite

      # Others
      bruno # API client
      gnumake
      tree-sitter
      codespell # code spell

    ];
  };
}
