{
  config,
  lib,
  ...
}: {
  options = {ghostty.enable = lib.mkEnableOption "enables ghostty module";};

  config = lib.mkIf config.ghostty.enable {
    catppuccin.ghostty.enable = true;
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        font-family = "JetBrainsMono Nerd Font";
        bold-is-bright = true;
        copy-on-select = true;
        window-decoration = "server";
        window-show-tab-bar = "auto";
        gtk-toolbar-style = "flat";
        adjust-underline-position = 4;
        background-opacity = 0.85;
        background-blur = 16;
        cursor-style = "block";
        custom-shader = "shaders/cursor_warp.glsl";
        keybind = [
          "ctrl+a>t=new_tab"
          "ctrl+a>n=next_tab"
          "ctrl+a>p=previous_tab"

          "ctrl+a>v=new_split:right"
          "ctrl+a>h=new_split:down"
          "unconsumed:ctrl+h=goto_split:left"
          "unconsumed:ctrl+l=goto_split:right"
          "unconsumed:ctrl+j=goto_split:down"
          "unconsumed:ctrl+k=goto_split:up"
          "unconsumed:ctrl+left=goto_split:left"
          "unconsumed:ctrl+right=goto_split:right"
          "unconsumed:ctrl+down=goto_split:down"
          "unconsumed:ctrl+up=goto_split:up"
          "ctrl+a>m=toggle_split_zoom"
          "unconsumed:alt+h=resize_split:left,10"
          "unconsumed:alt+j=resize_split:down,10"
          "unconsumed:alt+k=resize_split:up,10"
          "unconsumed:alt+l=resize_split:right,10"

          "ctrl+a>c=close_surface"
        ];
      };
    };
  };
}
