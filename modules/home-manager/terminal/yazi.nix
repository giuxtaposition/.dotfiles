{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {yazi.enable = lib.mkEnableOption "enables yazi module";};

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      package = pkgs.unstable.yazi;
      settings = {
        manager = {
          show_hidden = true;
          sort_by = "mtime";
          sort_dir_first = true;
        };
      };
      keymap = {
        manager = {
          prepend_keymap = [
            {
              on = "<C-n>";
              run = ''shell 'ripdrag "$@" -x 2>/dev/null &' --confirm'';
            }
            {
              on = "y";
              run = [''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'' "yank"];
            }
            {
              on = ["g" "r"];
              run = ''shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm'';
            }
          ];
        };
      };
    };

    catppuccin.yazi = {
      enable = true;
      accent = "lavender";
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
      ripdrag # drag and drop files from and to the terminal
    ];
  };
}
