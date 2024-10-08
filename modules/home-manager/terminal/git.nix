{ config, pkgs, lib, ... }: {

  options = { git.enable = lib.mkEnableOption "enables git module"; };

  config = lib.mkIf config.git.enable {
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

    programs.lazygit = {
      enable = true;
      settings = {
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        os = {
          editCommand = "nvim";
          editCommandTemplate = ''
            {{editor}} --server ~/.cache/nvim/$(pwd | sed 's/\\//-/g' | sed 's/^-//' | sed 's/\\//./g').pipe --remote-tab "{{filename}}"
          '';
        };
        promptToReturnFromSubprocess = false;
      };
      catppuccin = {
        enable = true;
        accent = "lavender";
      };
    };
  };
}
