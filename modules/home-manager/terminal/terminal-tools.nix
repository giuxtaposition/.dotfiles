{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {terminal-tools.enable = lib.mkEnableOption "enables terminal-tools module";};

  config = lib.mkIf config.terminal-tools.enable {
    programs = {
      # Bat - A cat clone with syntax highlighting and Git integration.
      bat = {
        enable = true;
      };

      # eza - A modern replacement for ls.
      eza = {
        enable = true;
        enableFishIntegration = true;
        icons = "always";
        colors = "always";
        git = true;
      };

      # Btop - A resource monitor that shows usage and stats for processor, memory, disks, network and processes.
      btop = {
        enable = true;
        package = pkgs.btop.override {rocmSupport = true;};
      };

      # Zoxide - A smarter cd command.
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      # Fzf - A command-line fuzzy finder.
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };

      # Fastfetch - A fast and minimalistic system information tool.
      fastfetch.enable = true;

      # Nix-index - A tool to index and search the Nix store.
      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };

      # Starship - A minimal, blazing-fast, and infinitely customizable prompt for any shell.
      starship = {
        enable = true;
        enableFishIntegration = true;
        enableInteractive = true;
        settings = {
          character = {
            success_symbol = "[[ᓚᘏᗢ](subtext1) ❯](sky)";
            error_symbol = "[❯](red)";
            vimcmd_symbol = "[❮](reen)";
          };
        };
      };
    };

    home = {
      packages = with pkgs; [
        dua # Disk usage analyzer with terminal interface
        ripgrep # Faster than grep
        fd # Faster than find
        xh # Faster than curl, with a simpler syntax and JSON support
        choose # A tool for interactively filtering and choosing from a list of items
        imagemagick # For image manipulation and previewing
        tree # For visualizing directory structures
      ];
    };
  };
}
