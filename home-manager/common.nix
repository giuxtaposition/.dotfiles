{
  outputs,
  pkgs,
  ...
}: {
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
  notes.enable = true;
  cleanup.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "teal";
    gtk.icon.enable = false;
    nvim.enable = false;
    swaylock.enable = false;
    # ponytail: pin to upstream rev with gui.theme.authorColors migration (catppuccin/lazygit#65),
    # drop once catppuccin/nix release-26.05 bumps sources.lazygit past 798ad2e.
    sources.lazygit = "${pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "lazygit";
      rev = "1a4b26cbc2b5be05cc5494d0d7f764120a2cf86d"; # v2.3.1
      hash = "sha256-TUrQcoA5T46Jvl9jeHiNO/+8ZddtUqRY6eDr51zGbYU=";
    }}/themes-mergable";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
