{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
{
  imports = [];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "giu";
    homeDirectory = "/home/giu";
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ 
    steam         
    aseprite      # Pixel Art Editor
    calibre       # Library Management
    deluge        # Torrent Client
    kazam         # Screenshot and screencast tool
    slack         # Messaging App
    discord       # Messaging App
    mpv-unwrapped # Media Player
    
    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ];})
  ];


  programs.neovim.enable = true;
  programs.home-manager.enable = true;


  # GIT CONFIG
  programs.git = {
    enable = true;
    userName = "giuxtaposition";
    userEmail = "yg97.cs@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  # GTK CONFIG
  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    font = {
      name = "JetBrains Mono";
    };
    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

   home.file."${config.home.homeDirectory}/.config/nvim" = {
     source = ../.config/nvim;
   };
  
   home.file."${config.home.homeDirectory}/.config/awesome" = {
     source = ../.config/awesome;
   };

   home.file."${config.home.homeDirectory}/.config/wezterm" = {
     source = ../.config/wezterm;
   };

   home.file."${config.home.homeDirectory}/.config/fish" = {
     source = ../.config/fish;
   };

   home.file."${config.home.homeDirectory}/.config/rofi" = {
     source = ../.config/rofi;
   };
  
   home.file."${config.home.homeDirectory}/.config/neofetch" = {
     source = ../.config/neofetch;
   };
  
   home.file."${config.home.homeDirectory}/.config/starship.toml" = {
     source = ../.config/starship.toml;
   }; 
  
   home.file."${config.home.homeDirectory}/.config/lazygit/config.yml" = {
     source = ../.config/lazygit/config.yml;
   };
  
   home.file."${config.home.homeDirectory}/.local/share/icons/candy-icons" = {
     source = pkgs.candy-icons;
   };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
