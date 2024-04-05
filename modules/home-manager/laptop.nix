{ lib, config, ... }: {

  options = { laptop.enable = lib.mkEnableOption "enables laptop module"; };

  config = lib.mkIf config.laptop.enable {
    home.sessionVariables = {
      KEYBOARD_NAME = "1:1:AT_Translated_Set_2_keyboard";
    };

  };
}
