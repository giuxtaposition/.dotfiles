{
  # Terminal
  terminal-tools = import ./terminal/terminal-tools.nix;
  fish = import ./terminal/fish.nix;
  git = import ./terminal/git.nix;
  nvim = import ./terminal/nvim.nix;
  yazi = import ./terminal/yazi.nix;
  direnv = import ./terminal/direnv.nix;
  kitty = import ./terminal/kitty.nix;
  notes = import ./terminal/notes.nix;

  # WM
  wayland = import ./wm/wayland.nix;
  niri = import ./wm/niri.nix;
  noctalia-shell = import ./wm/noctalia-shell.nix;

  # Others
  work = import ./work.nix;
  media = import ./media.nix;
  gaming = import ./gaming.nix;
  coding = import ./coding;
  colors = import ./colors.nix;
  mpv = import ./mpv.nix;
}
