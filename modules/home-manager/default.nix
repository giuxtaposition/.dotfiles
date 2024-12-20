{
  # Terminal
  bat = import ./terminal/bat.nix;
  fish = import ./terminal/fish.nix;
  git = import ./terminal/git.nix;
  nvim = import ./terminal/nvim.nix;
  wezterm = import ./terminal/wezterm.nix;
  btop = import ./terminal/btop.nix;
  yazi = import ./terminal/yazi.nix;
  direnv = import ./terminal/direnv.nix;

  # WM
  wayland = import ./wm/wayland.nix;
  sway = import ./wm/sway.nix;
  niri = import ./wm/niri.nix;
  cassiopea = import ./wm/cassiopea.nix;

  # Others
  spotify = import ./spotify.nix;
  monitors = import ./monitors.nix;
  laptop = import ./laptop.nix;
  coding = import ./coding.nix;
  colors = import ./colors.nix;
}
