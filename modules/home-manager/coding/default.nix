{
  lib,
  config,
  pkgs,
  ...
}: {
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
    nvim.enable = true;
    bat.enable = true;
    fish.enable = true;
    git.enable = true;
    direnv.enable = true;

    home.packages = with pkgs;
      [
        chromium

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
        vtsls
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
      # Key must match the package's .desktop filename to shadow it.
      # home-manager writes ~/.local/share/applications/mongodb-compass.desktop
      # which takes XDG precedence over the system-level entry from the package.
      "mongodb-compass" = {
        name = "MongoDB Compass";
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
