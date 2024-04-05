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

  laptop.enable = true;

  home.sessionVariables = {
    BATTERY_INFO_LOCATION = "/sys/class/power_supply/BAT1/";
  };

  programs.fish.shellAbbrs = {
    home-update = "z dot && home-manager switch --flake .#giu@asuka";
    nixos-update = "z dot && sudo nixos-rebuild switch --flake .#asuka";
  };
}
