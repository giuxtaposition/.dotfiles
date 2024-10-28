{pkgs, ...}: {
  imports = [./common.nix];

  monitors = [
    {
      name = "eDP-1";
      index = 0;
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];

  laptop.enable = true;

  programs.fish.shellAbbrs = {
    home-update = "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@kumiko";
    nixos-update = "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#kumiko";
  };

  home.packages = with pkgs; [
    deluge # Torrent Client
    opera
    calibre # Library Management
  ];
}
