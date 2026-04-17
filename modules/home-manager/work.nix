{
  lib,
  config,
  pkgs,
  ...
}: let
  firefoxWork = pkgs.makeDesktopItem {
    name = "firefox-work-profile";
    desktopName = "Firefox Work Profile";
    exec = ''firefox -P "work"'';
    terminal = false;
    icon = "firefox";
  };
in {
  options.work.enable = lib.mkEnableOption "enables work environment";

  config = lib.mkIf config.work.enable {
    home.packages = [
      pkgs.slack
      firefoxWork
    ];

    programs.git.includes = [
      {
        condition = "gitdir:~/Programming/vitesicure/";
        contents.user = {
          email = "gye@vitesicure.it";
          name = "Giulia Ye";
        };
      }
    ];
  };
}
