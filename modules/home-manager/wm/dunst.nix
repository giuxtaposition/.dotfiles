{ config, lib, pkgs, ... }: {

  options = { dunst.enable = lib.mkEnableOption "enables dunst module"; };

  config = lib.mkIf config.dunst.enable {
    # notification daemon
    services.dunst = let
      crust = "#11111b";
      text = "#cdd6f4";
      c = {
        error_background = "${crust}";
        error_foreground = "${text}";
        error_frame = "#f38ba8";
        secondary_background = "${crust}";
        secondary_foreground = "${text}";
        secondary_frame = "#cba6f7";
        primary_background = "${crust}";
        primary_foreground = "${text}";
        primary_frame = "#b4befe";
      };
    in {
      enable = true;
      settings = {
        global = {
          browser = "${config.programs.firefox.package}/bin/firefox -new-tab";
          corner_radius = 8;
          follow = "mouse"; # follow monitor with mouse
          font = "JetBrainsMono Nerd Font 11";
          format = "<b>%a</b>\\n%s\\n%b";
          alignment = "left";
          frame_width = 1;
          offset = "5x5";
          icon_position = "left";
          enable_recursive_icon_lookup = true;
          indicate_hidden = "yes";
          markup = "full";
          max_icon_size = 64;
          mouse_left_click = "do_action";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
          horizontal_padding = 16;
          padding = 16;
          separator_color = "#272f57";
          separator_height = 6;
          show_indicators = false;
          shrink = "no";
          word_wrap = "yes";
        };

        fullscreen_delay_everything = { fullscreen = "delay"; };

        urgency_critical = {
          background = c.error_background;
          foreground = c.error_foreground;
          frame_color = c.error_frame;
        };
        urgency_low = {
          background = c.secondary_background;
          foreground = c.secondary_foreground;
          frame_color = c.secondary_frame;
        };
        urgency_normal = {
          background = c.primary_background;
          foreground = c.primary_foreground;
          frame_color = c.primary_frame;
        };
      };
      iconTheme = {
        name = "candy-icons";
        package = pkgs.candy-icons;
      };
    };
  };
}
