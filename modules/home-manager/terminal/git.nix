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
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    catppuccin.delta.enable = true;

    programs.jujutsu = {
      enable = true;
      package = pkgs.unstable.jujutsu;
      settings = {
        user = {
          name = "giuxtaposition";
          email = "yg97.cs@gmail.com";
        };
        ui = {
          "default-command" = ["log"];
          paginate = "never";
        };
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git.pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        os = {
          edit = "nvim";
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
