{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {git.enable = lib.mkEnableOption "enables git module";};

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "giuxtaposition";
      userEmail = "yg97.cs@gmail.com";
      extraConfig = {
        core = {editor = "nvim";};
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;

        init.defaultBranch = "main";
        merge = {
          tool = "fugitive";
        };
        mergetool = {
          fugitive = {
            cmd = ''nvim -f -c \"Gvdiff\" \"$MERGED\"'';
          };
        };
      };

      includes = [
        {
          condition = "gitdir:~/Programming/vitesicure/";
          contents = {
            user = {
              email = "gye@vitesicure.it";
              name = "Giulia Ye";
            };
          };
        }
      ];

      delta = {
        enable = true;
      };
    };
    catppuccin.delta.enable = true;

    programs.lazygit = {
      enable = true;
      settings = {
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        os = {
          editCommand = "nvim";
        };
        promptToReturnFromSubprocess = false;
      };
    };

    catppuccin.lazygit = {
      enable = true;
      accent = "lavender";
    };
  };
}
