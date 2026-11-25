{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {kitty.enable = lib.mkEnableOption "enables kitty module";};

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      # enableGitIntegration = true;
      # Windows, tabs, splits, lazygit, the test runner, scrollback search and
      # the file:line hints all live in tmux now (the hints as `prefix e`), so
      # kitty binds none of their keys and passes Ctrl/Alt + hjkl/arrows
      # straight through. `kitten hints` cannot stay: it hands the program the
      # directory of the window's foreground process, which under tmux is the
      # client's, not the pane's, and nvim-open needs the pane's to find the
      # right socket.
      # Exception: shift+enter. Kitty only reports it when the app negotiates
      # the keyboard protocol, which Claude Code does not, so it arrives as a
      # plain Enter and submits the prompt. Send Esc+Enter instead — tmux
      # passes the two bytes straight through and Claude Code inserts a
      # newline.
      keybindings = {
        "shift+enter" = "send_text all \\x1b\\r";
      };
      settings =
        lib.optionalAttrs config.tmux.enable {
          # Every kitty window is a tmux client. -A attaches to `main` when it is
          # already there, including when continuum has just restored it on the
          # first window after a boot, and creates it otherwise. Putting this
          # here rather than in the fish config keeps nvim's `:terminal`, `fish
          # -c`, and script shells out of tmux.
          shell = "${pkgs.tmux}/bin/tmux new-session -A -s main";
        }
        // {
          background_opacity = "0.9";
          background_blur = "5";
          font_family = "JetBrainsMono Nerd Font Mono";
          modify_font = "cell_height 110%";
          cursor_shape = "block";
          cursor_trail = "1";
          copy_on_select = "true";
          tab_bar_min_tabs = "2";
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          undercurl_style = "thick-dense";
          focus_follows_mouse = "true";
          allow_remote_control = "yes";
          listen_on = "unix:@mykitty";
          scrollback_lines = "5000";
          scrollback_pager_history_size = "10";
        };
    };
  };
}
