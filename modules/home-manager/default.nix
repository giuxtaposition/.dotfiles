{
  monitors = import ./monitors.nix;
  laptop = import ./laptop.nix;

  # Terminal
  bat = import ./terminal/bat.nix;
  fish = import ./terminal/fish.nix;
  git = import ./terminal/git.nix;
  nvim = import ./terminal/nvim.nix;
  wezterm = import ./terminal/wezterm.nix;
  foot = import ./terminal/foot.nix;

  # WM
  wayland = import ./wm/wayland.nix;
  sway = import ./wm/sway.nix;
  dunst = import ./wm/dunst.nix;
  eww = import ./wm/eww.nix;
}
