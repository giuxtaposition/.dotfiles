{ pkgs, lib, self, inputs, config, ... }: {
  imports = [ ./dunst.nix ./hyprland.nix ];
}
