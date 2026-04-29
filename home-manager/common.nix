{outputs, ...}: {
  imports = builtins.attrValues outputs.homeManagerModules;
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "giu";
    homeDirectory = "/home/giu";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  bat.enable = true;
  fish.enable = true;
  git.enable = true;
  nvim.enable = true;
  btop.enable = true;
  yazi.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
