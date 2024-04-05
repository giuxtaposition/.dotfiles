{ lib, config, ... }: {

  options = { laptop.enable = lib.mkEnableOption "enables laptop module"; };

  config = lib.mkIf config.laptop.enable {
    home.sessionVariables = {
      KEYBOARD_NAME = "1:1:AT_Translated_Set_2_keyboard";
    };

    wayland.windowManager.sway.config.input = {
      "1:1:AT_Translated_Set_2_keyboard" = {
        xkb_options = "ctrl:swapcaps,grp:alt_shift_toggle";
      };
    };
  };
}
