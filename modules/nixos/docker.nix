{ ... }: {
  virtualisation.docker.enable = true;
  users.users.giu.extraGroups = [ "docker" ];
}
