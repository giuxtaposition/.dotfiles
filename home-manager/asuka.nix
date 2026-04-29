{...}: {
  imports = [./common.nix ./desktop.nix];

  niri.xkbOptions = "ctrl:swapcaps";

  niri.extraConfig = ''
    output "eDP-1" {
        mode "2256x1504"
        scale 1.25
        position x=0 y=0
    }

    spawn-at-startup "swayidle" "-w" "timeout" "300" "swaylock -f -c 000000" "timeout" "600" "systemctl suspend" "before-sleep" "swaylock -f -c 000000"
  '';

  work.enable = true;

  coding = {
    enable = true;
    typescript.enable = true;
    lua.enable = true;
    nix.enable = true;
    bash.enable = true;
    markdown.enable = true;
  };

  programs.fish.shellAbbrs = {
    home-update = "cd /home/giu/.dotfiles && home-manager switch --flake .#giu@asuka";
    nixos-update = "cd /home/giu/.dotfiles && sudo nixos-rebuild switch --flake .#asuka";
  };
}
