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
  options.coding = {
    enable = lib.mkEnableOption "enables coding module";
    typescript.enable = lib.mkEnableOption "enables TypeScript/JavaScript development";
    lua.enable = lib.mkEnableOption "enables Lua development";
    nix.enable = lib.mkEnableOption "enables Nix development";
    kotlin.enable = lib.mkEnableOption "enables Kotlin development";
    rust.enable = lib.mkEnableOption "enables Rust development";
    go.enable = lib.mkEnableOption "enables Go development";
    bash.enable = lib.mkEnableOption "enables Bash/Shell development";
    c.enable = lib.mkEnableOption "enables C/C++ development";
    markdown.enable = lib.mkEnableOption "enables Markdown editing";
    php.enable = lib.mkEnableOption "enables PHP development";
    latex.enable = lib.mkEnableOption "enables LaTeX editing";
    vue.enable = lib.mkEnableOption "enables Vue.js development";
    svelte.enable = lib.mkEnableOption "enables Svelte development";
  };

  config = lib.mkIf config.coding.enable {
    home.sessionVariables = {
      MONGOMS_DISTRO = "ubuntu-22.04";
    };

    nvim.enable = true;
    bat.enable = true;
    fish.enable = true;
    git.enable = true;
    wezterm.enable = true;
    direnv.enable = true;

    home.packages = with pkgs;
      [
        chromium
        firefoxWork
        firefoxWorkScript

        # DBs
        mongodb-compass
        sqlite

        # Common tools
        gnumake
        tree-sitter
        insomnia
        harper

        unstable.copilot-language-server
        unstable.opencode
        claude-code
      ]
      ++ lib.optionals config.coding.typescript.enable [
        vscode-langservers-extracted
        nodePackages_latest.typescript-language-server
        emmet-ls
        prettierd
        eslint_d
        vtsls
        tailwindcss-language-server
        nodejs_24
        vscode-js-debug
        pnpm
        unstable.typescript-go
      ]
      ++ lib.optionals config.coding.vue.enable [
        vue-language-server
        vscode-extensions.vue.vscode-typescript-vue-plugin
      ]
      ++ lib.optionals config.coding.svelte.enable [
        nodePackages_latest.svelte-language-server
      ]
      ++ lib.optionals config.coding.lua.enable [
        lua-language-server
        stylua
        luajitPackages.luacheck
      ]
      ++ lib.optionals config.coding.nix.enable [
        nixd
        alejandra
      ]
      ++ lib.optionals config.coding.kotlin.enable [
        kotlin
        kotlin-language-server
        gradle
        jdk
        ktlint
      ]
      ++ lib.optionals config.coding.rust.enable [
        rustc
        cargo
        rust-analyzer
        rustfmt
        vscode-extensions.vadimcn.vscode-lldb
      ]
      ++ lib.optionals config.coding.go.enable [
        go
        gopls
        gofumpt
        delve
      ]
      ++ lib.optionals config.coding.bash.enable [
        nodePackages_latest.bash-language-server
        shellcheck
        shfmt
      ]
      ++ lib.optionals config.coding.c.enable [
        libclang
        cmake
      ]
      ++ lib.optionals config.coding.markdown.enable [
        marksman
        markdownlint-cli
      ]
      ++ lib.optionals config.coding.php.enable [
        phpactor
        php83Packages.php-cs-fixer
        intelephense
      ]
      ++ lib.optionals config.coding.latex.enable [
        pplatex
        texlab
        texliveFull
        libxml2
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
