{ ... }: {
  programs.foot = let themeColors = import ../../colors.nix;
  in {
    enable = false;

    settings = {
      main = {
        font = "JetBrains Mono Nerd Font:size=14";
        dpi-aware = "yes";
        pad = "8x8";
        term = "xterm-256color";
      };
      cursor = {
        style = "block";
        color = "${themeColors.base} ${themeColors.lavender}";
        beam-thickness = "1";
        blink = "no";
      };

      mouse.hide-when-typing = "yes";
      colors = {
        alpha = "0.9";
        foreground = themeColors.text;
        background = themeColors.base;
        regular0 = themeColors.surface1;
        regular1 = themeColors.red;
        regular2 = themeColors.green;
        regular3 = themeColors.yellow;
        regular4 = themeColors.blue;
        regular5 = themeColors.pink;
        regular6 = themeColors.teal;
        regular7 = themeColors.subtext1;
        bright0 = themeColors.surface2;
        bright1 = themeColors.red;
        bright2 = themeColors.green;
        bright3 = themeColors.yellow;
        bright4 = themeColors.blue;
        bright5 = themeColors.pink;
        bright6 = themeColors.teal;
        bright7 = themeColors.subtext0;
      };
    };
  };
}
