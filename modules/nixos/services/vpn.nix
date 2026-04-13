# Gluetun VPN + qBittorrent — encrypted torrent downloading
#
# Architecture:
#   Gluetun creates a VPN tunnel to ProtonVPN. qBittorrent shares
#   Gluetun's network namespace, so ALL torrent traffic transits
#   through the encrypted tunnel — never the host's direct internet.
#
# Killswitch:
#   FIREWALL_OUTBOUND_SUBNETS limits non-VPN traffic to LAN only.
#   If the VPN drops, Gluetun's built-in firewall blocks all internet traffic.
#
# Port forwarding:
#   VPN_PORT_FORWARDING=on enables ProtonVPN's port mapping protocol (+pmp),
#   allowing incoming torrent peer connections through the VPN tunnel.
#
# Credentials:
#   Managed via sops-nix — decrypted at activation to /run/secrets/.
#   NEVER put credentials in .nix files.
{
  lib,
  config,
  ...
}: let
  hasSecrets = builtins.pathExists ../../../secrets/secrets.yaml;
in {
  options = {vpn.enable = lib.mkEnableOption "VPN tunnel with Gluetun + qBittorrent (Podman containers)";};

  config = lib.mkIf config.vpn.enable {
    # Podman runtime for OCI containers
    virtualisation.podman.enable = true;

    virtualisation.oci-containers = {
      backend = "podman";

      # Gluetun VPN tunnel container
      containers.gluetun = {
        image = "qmcgaw/gluetun:latest";

        # NET_ADMIN: required for creating the VPN tunnel interface (tun0)
        # /dev/net/tun: Linux TUN/TAP device
        # --dns: explicit DNS to avoid leaking host DNS
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun"
          "--dns=1.1.1.1"
        ];

        environment = {
          VPN_SERVICE_PROVIDER = "protonvpn";
          SERVER_COUNTRIES = "Italy";
          FREE_ONLY = "off";
          VPN_PORT_FORWARDING = "on";
          VPN_PORT_FORWARDING_PROVIDER = "protonvpn";
          TZ = "Europe/Rome";
          # Killswitch: only allow LAN traffic when VPN is down
          FIREWALL_OUTBOUND_SUBNETS = "192.168.0.0/16,172.16.0.0/12";
          DOT = "off";
        };

        # VPN credentials via sops-nix env file (OPENVPN_USER + OPENVPN_PASSWORD)
        environmentFiles = lib.mkIf hasSecrets [
          config.sops.secrets."vpn/protonvpn/env-file".path
        ];

        # Ports published through Gluetun for qBittorrent
        # 8001:8080 — qBittorrent WebUI
        # 6881 — incoming torrent peer connections (TCP + UDP)
        ports = [
          "8001:8080"
          "6881:6881"
          "6881:6881/udp"
        ];

        volumes = [
          "/var/lib/gluetun:/gluetun"
        ];
      };

      # qBittorrent — torrent downloader routed through Gluetun
      #
      # --network=container:gluetun shares Gluetun's entire network namespace.
      # qBittorrent has NO separate network interface — ALL traffic transits
      # through the VPN tunnel exclusively.
      #
      # If the VPN drops, qBittorrent cannot reach the internet at all.
      containers.qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";

        dependsOn = ["gluetun"];

        extraOptions = [
          "--network=container:gluetun"
          "--security-opt=no-new-privileges:true"
        ];

        environment = {
          TZ = "Europe/Rome";
          PUID = "1000";
          PGID = "1000";
          UMASK_SET = "002";
        };

        volumes = [
          "/var/lib/qbittorrent:/config"
          "/media/downloads:/media/downloads"
        ];
      };
    };

    # VPN secret declaration (only when secrets file exists)
    sops.secrets."vpn/protonvpn/env-file" = lib.mkIf hasSecrets {};

    # Data directories
    systemd.tmpfiles.rules = [
      "d /var/lib/gluetun 0750 root root - -"
      "d /var/lib/qbittorrent 0750 1000 media - -"
      "d /media/downloads 0775 1000 media - -"
    ];

    # qBittorrent WebUI access from LAN
    networking.firewall.allowedTCPPorts = [8001];
  };
}
