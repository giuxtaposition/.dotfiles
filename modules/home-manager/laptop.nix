{ lib, config, ... }: {

  options = { laptop.enable = lib.mkEnableOption "enables laptop module"; };

  config = lib.mkIf config.laptop.enable {
    ags.keyboard_name =
      lib.mkIf config.ags.enable "1:1:AT_Translated_Set_2_keyboard";
  };
}
