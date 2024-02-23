{ ... }: {
  imports = [ ./common.nix ];

  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      refreshRate = 144;
      x = 0;
      workspace = "1";
      primary = true;
      topbar = "bar1";
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
      workspace = "2";
      topbar = "bar0";
    }
  ];

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    KEYBOARD_NAME = "36125:13370:splitkb.com_Aurora_Corne_rev1";
  };

  programs.fish.shellAbbrs = {
    home-update = "z dot && home-manager switch --flake .#giu@reina";
    nixos-update = "z dot && sudo nixos-rebuild switch --flake .#reina";
  };
}
