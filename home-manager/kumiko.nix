{...}: {
  imports = [./common.nix];

  coding = {
    enable = true;
    nix.enable = true;
    bash.enable = true;
  };

  programs.fish.shellAbbrs = {
    home-update = "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@kumiko";
    nixos-update = "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#kumiko";
  };
}
