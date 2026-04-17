{
  config,
  lib,
  ...
}: {
  options = {git.enable = lib.mkEnableOption "enables git module";};

  config = lib.mkIf config.git.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "giuxtaposition";
            email = "yg97.cs@gmail.com";
          };
          core = {editor = "nvim";};
          pull.rebase = true;
          push.autoSetupRemote = true;
          fetch.prune = true;

          init.defaultBranch = "main";
          merge = {tool = "fugitive";};
          mergetool = {
            fugitive = {cmd = ''nvim -f -c \"Gvdiff\" \"$MERGED\"'';};
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
      };

      difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
      };

      lazygit = {
        enable = true;
        settings = {
          git.pagers = [
            {
              "externalDiffCommand" = "difft --color=always --display=inline";
            }
          ];
          os = {edit = "nvim";};
          promptToReturnFromSubprocess = false;
        };
      };
    };

    catppuccin.lazygit = {
      enable = true;
      accent = "lavender";
    };
  };
}
