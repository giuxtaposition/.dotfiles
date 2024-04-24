{ ... }: {
  imports = [ ./common.nix ];

  monitors = [{
    name = "eDP-1";
    index = 0;
    width = 1920;
    height = 1080;
    x = 0;
    workspace = "1";
    primary = true;
  }];

  laptop.enable = true;

  programs.fish.shellAbbrs = {
    home-update = "z dot && home-manager switch --flake .#giu@kumiko";
    nixos-update = "z dot && sudo nixos-rebuild switch --flake .#kumiko";
  };
}
