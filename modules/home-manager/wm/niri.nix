{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {niri.enable = lib.mkEnableOption "enables niri module";};

  config = lib.mkIf config.niri.enable {
    home.packages = with pkgs; [xwayland-satellite];

    home.file."${config.home.homeDirectory}/.config/niri" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/niri";
    };
  };
}
