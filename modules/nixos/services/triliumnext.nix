# TriliumNext — Personal hierarchical notes (Podman container)
#
# No native NixOS module exists, so this runs as a Podman container.
{
  lib,
  config,
  ...
}: {
  options = {triliumnext.enable = lib.mkEnableOption "TriliumNext notes application (Podman container)";};

  config = lib.mkIf config.triliumnext.enable {
    virtualisation.podman.enable = true;

    virtualisation.oci-containers = {
      backend = "podman";

      containers.triliumnext = {
        image = "triliumnext/trilium:latest";

        extraOptions = [
          "--security-opt=no-new-privileges:true"
        ];

        environment = {
          TRILIUM_DATA_DIR = "/home/node/trilium-data";
          TZ = "Europe/Rome";
        };

        ports = [
          "8080:8080"
        ];

        volumes = [
          "/media/trilium-data:/home/node/trilium-data"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d /media/trilium-data 0750 1000 1000 - -"
    ];

    networking.firewall.allowedTCPPorts = [8080];
  };
}
