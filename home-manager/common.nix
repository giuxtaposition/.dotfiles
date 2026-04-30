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

  terminal-tools.enable = true;
  fish.enable = true;
  git.enable = true;
  nvim.enable = true;
  yazi.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "teal";
    gtk.icon.enable = false;
    nvim.enable = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
