{ ... }: {
  imports = [ ./common.nix ];

  monitors = [{
    name = "eDP-1";
    width = 2256;
    height = 1504;
    x = 0;
    workspace = "1";
    primary = true;
    topbar = "bar0";
  }];

  home.sessionVariables = {
    KEYBOARD_NAME = "1:1:AT_Translated_Set_2_keyboard";
  };

  programs.fish.shellAbbrs = {
    home-update = "z dot && home-manager switch --flake .#giu@asuka";
    nixos-update = "z dot && sudo nixos-rebuild switch --flake .#asuka";
  };
}
