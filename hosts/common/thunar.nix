{ ... }: {
  programs.thunar.enable = true;
  programs.xfconf.enable = true; # Save preferences
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
