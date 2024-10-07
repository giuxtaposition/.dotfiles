{ config, pkgs, lib, ... }: {

  options = { yazi.enable = lib.mkEnableOption "enables yazi module"; };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      catppuccin.enable = true;
    };

    home.packages = with pkgs; [
      file # file type detection
      ffmpegthumbnailer # video thumbnails
      p7zip # for archive extraction and preview
      jq # json preview
      poppler # pdf preview
      fd # file searching
      ripgrep # file content searching
      fzf # quick file subtree navigation
      zoxide # historical directories navigation
      imagemagick # svg, font, heic and jpeg XL preview
      wl-clipboard # system clipboard support
    ];
  };
}
