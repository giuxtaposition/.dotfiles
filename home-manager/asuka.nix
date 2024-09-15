{ ... }: {
  imports = [ ./common.nix ];

  monitors = [{
    name = "eDP-1";
    index = 0;
    width = 2256;
    height = 1504;
    x = 0;
    workspace = "1";
    primary = true;
    scale = 1.25;
  }];

  laptop.enable = true;
  coding.enable = true;

  programs.fish.shellAbbrs = {
    home-update =
      "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@asuka";
    nixos-update =
      "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#asuka";
  };

}
