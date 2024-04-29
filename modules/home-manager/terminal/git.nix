{ config, pkgs, lib, ... }: {

  options = { git.enable = lib.mkEnableOption "enables git module"; };

  config = lib.mkIf config.git.enable {
    home.packages = with pkgs; [ lazygit ];

    home.file."${config.home.homeDirectory}/.config/lazygit/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/lazygit/config.yml";
    };

    home.file."${config.home.homeDirectory}/.config/delta/themes.gitconfig" =
      let
        green = "#475a51";
        red = "#5f3f53";
        dark-green = "#333c3f";
        dark-red = "#3f2f40";
        emph-green = "#566f5d";
        emph-red = "#764b60";
        text = "#cdd6f4";
        bg = "#1e1e2e";
      in {
        text = ''
          [core]
          pager = delta

          [interactive]
          diffFilter = delta --color-only

          [delta]
          navigate = true    # use n and N to move between diff sections
          light = false

          [merge]
          conflictstyle = diff3

          [diff]
          colorMoved = default

          [delta "giuxtaposition"]
          dark = true
          side-by-side = true
          syntax-theme = Catppuccin Mocha

          # File
          file-style = "${text}" bold
          file-added-label = [+]
          file-copied-label = [==]
          file-modified-label = [*]
          file-removed-label = [-]
          file-renamed-label = [->]
          file-decoration-style = "#434C5E" ul

          # No hunk headers
          hunk-header-style = omit

          # Line numbers
          line-numbers = true
          line-numbers-left-style = "${text}" "${bg}"
          line-numbers-right-style = "${text}" "${bg}"
          line-numbers-minus-style = "${text}" "${red}"
          line-numbers-plus-style = "${text}" "${green}"
          line-numbers-zero-style = "${text}" "${bg}"
          line-numbers-left-format = " {nm:>3} │"
          line-numbers-right-format = " {np:>3} │"

          # Diff contents
          inline-hint-style = syntax
          minus-style = syntax "${dark-red}"
          minus-emph-style = syntax "${emph-red}"
          plus-style = syntax "${dark-green}"
          plus-emph-style = syntax "${emph-green}"

          # Commit hash
          commit-style = "${text}" bold

          # Blame
          blame-code-style = syntax
          blame-format = "{author:>18} ({commit:>8}) {timestamp:<13} "
          blame-palette = "#000000" "#1d2021" "#282828" "#3c3836"

          # Merge conflicts
          merge-conflict-begin-symbol = ⌃
          merge-conflict-end-symbol = ⌄
          merge-conflict-ours-diff-header-style = "#FABD2F" bold
          merge-conflict-theirs-diff-header-style = "#FABD2F" bold overline
          merge-conflict-ours-diff-header-decoration-style = ""
          merge-conflict-theirs-diff-header-decoration-style = ""    
        '';
      };

    programs.git = {
      enable = true;
      userName = "giuxtaposition";
      userEmail = "yg97.cs@gmail.com";
      extraConfig = {
        core = { editor = "nvim"; };
        pull.rebase = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };

      includes = [
        {
          path = "${config.home.homeDirectory}/.config/delta/themes.gitconfig";
        }
        {
          condition = "gitdir:~/Programming/vitesicure/";
          contents = {
            user = {
              email = "gye@vitesicure.it";
              name = "Giulia Ye";
            };
          };
        }
      ];

      delta = {
        enable = true;
        options = {
          features = "giuxtaposition";
          dark = true;
        };
      };
    };
  };
}
