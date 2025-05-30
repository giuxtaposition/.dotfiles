{
  lib,
  config,
  pkgs,
  ...
}: let
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
  options = {coding.enable = lib.mkEnableOption "enables coding module";};

  config = lib.mkIf config.coding.enable {
    home.sessionVariables = {
      MONGOMS_DISTRO = "ubuntu-22.04"; # MONGO MEMORY SERVER not supporting nixos
      CYPRESS_INSTALL_BINARY = "0";
      CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress";

      ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/notes";
    };

    nvim.enable = true;
    bat.enable = true;
    fish.enable = true;
    git.enable = true;
    wezterm.enable = true;
    direnv.enable = true;

    home.packages = with pkgs; [
      chromium
      firefoxWork
      firefoxWorkScript

      # Typescript/Javascript
      cypress
      vscode-langservers-extracted
      nodePackages_latest.typescript-language-server
      nodePackages_latest.svelte-language-server
      vscode-extensions.vue.volar # vue language server
      emmet-ls
      prettierd # typescript formatter
      eslint_d # typescript linter
      vtsls
      tailwindcss-language-server
      bun
      vue-language-server
      nodejs_24
      deno
      vscode-js-debug
      pnpm

      # Lua
      lua-language-server
      stylua # lua formatter
      luajitPackages.luacheck # lua linter

      # Nix
      nixd # language server
      alejandra # formatter

      # Kotlin
      kotlin
      kotlin-language-server
      gradle
      jdk
      ktlint

      # Rust
      rustc
      cargo
      rust-analyzer
      rustfmt

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
      gnumake
      tree-sitter
      vscode-extensions.vadimcn.vscode-lldb
      libxml2 # xml parser
      insomnia
      zk
      harper
      pplatex
      texlab
      texliveFull
    ];

    xdg.desktopEntries = {
      mongo_db_compass = {
        name = "MongoDB Compass Working Secret";
        genericName = "The MongoDB Compass";
        exec = "mongodb-compass --password-store=\"gnome-libsecret\" --ignore-additional-command-line-flags %U";
        terminal = false;
        icon = "mongodb-compass";
        categories = ["GNOME" "GTK" "Utility"];
        mimeType = ["x-scheme-handler/mongodb" "x-scheme-handler/mongodb+srv"];
      };
    };
  };
}
