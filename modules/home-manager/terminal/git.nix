{ config, pkgs, lib, ... }: {

  options = { git.enable = lib.mkEnableOption "enables git module"; };

  config = lib.mkIf config.git.enable {
    home.packages = with pkgs; [ lazygit ];

    home.file."${config.home.homeDirectory}/.config/lazygit/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/lazygit/config.yml";
    };

    programs.git = {
      enable = true;
      userName = "giuxtaposition";
      userEmail = "yg97.cs@gmail.com";
      extraConfig = {
        core = { editor = "nvim"; };
        pull.rebase = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };

      includes = [{
        condition = "gitdir:~/Programming/vitesicure/";
        contents = {
          user = {
            email = "gye@vitesicure.it";
            name = "Giulia Ye";
          };
        };
      }];

      delta = {
        enable = true;
        catppuccin.enable = true;
      };
    };
  };
}
