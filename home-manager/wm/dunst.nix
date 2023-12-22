{ config, ... }: {

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
    inherit (config.gtk) iconTheme;
    settings = {
      global = {
        alignment = "center";
        corner_radius = 16;
        follow = "mouse";
        font = "Inter 9";
        format = "<b>%s</b>\\n%b";
        frame_width = 1;
        offset = "5x5";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
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
  };
}
