{...}: {
  imports = [./common.nix];

  programs.niri.settings = {
    outputs = {
      "eDP-1" = {
        mode = {
          width = 2256;
          height = 1504;
        };
        scale = 1.25;
        position = {
          x = 0;
          y = 0;
        };
      };
    };
    input.keyboard.xkb.options = "ctrl:swapcaps";
    spawn-at-startup = [
      {command = ["swayidle" "-w" "timeout" "300" "swaylock -f -c 000000" "timeout" "600" "systemctl suspend" "before-sleep" "swaylock -f -c 000000"];}
    ];
  };

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
