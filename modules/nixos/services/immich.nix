# Immich — Self-hosted Photo/Video Management
#
# Package comes from nixpkgs-unstable: 26.05 ships Immich 2.x, which is EOL
# and marked insecure (CVE-2026-59258, CVE-2026-82272). The 26.05 module
# drives 3.x unchanged — it only needs `package.machine-learning`, which the
# unstable package still provides.
{
  lib,
  config,
  pkgs,
  ...
}: let
  hasSecrets = builtins.pathExists ../../../secrets/secrets.yaml;

  # From `cloudflared tunnel create immich` — the UUID it prints, and the
  # hostname routed to it with `cloudflared tunnel route dns`.
  cloudflareTunnelId = "0651d3d4-4d3a-4683-b052-314be9532ecc";
  publicHostname = "photos.giuliaye.com";
in {
  options = {immich.enable = lib.mkEnableOption "Immich photo/video management";};

  config = lib.mkIf config.immich.enable {
    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
      openFirewall = true; # Port 2283
      mediaLocation = "/media/immich";
      machine-learning.enable = true;
      host = "0.0.0.0";
    };

    systemd.tmpfiles.rules = [
      "d /media/immich 0770 immich immich - -"
    ];

    # Public access via Cloudflare Tunnel, gated by Cloudflare Access.
    #
    # cloudflared dials out from kumiko and holds the connection open, so no
    # port is forwarded, the firewall stays shut, and the home IP never appears
    # in public DNS — the hostname resolves to Cloudflare's edge.
    #
    # Cloudflare Access sits in front: visitors authenticate to Cloudflare
    # (one-time PIN by email) before any request reaches this machine, so the
    # Immich login page is never publicly reachable. Configure the Access
    # application separately in the Zero Trust dashboard; nothing about it
    # lives here.
    #
    # Known limit: the free plan caps request bodies at 100 MB, which breaks
    # large uploads through the tunnel. Upload over the tailnet or LAN instead
    # — the cap applies to requests, not responses, so browsing and downloads
    # are unaffected.
    # Stays 0400 root:root: the unit runs as a DynamicUser but picks the file
    # up through systemd `LoadCredential`, which reads it as root beforehand.
    sops.secrets."cloudflared/immich/credentials" = lib.mkIf hasSecrets {};

    services.cloudflared = {
      enable = true;
      tunnels.${cloudflareTunnelId} = {
        credentialsFile = config.sops.secrets."cloudflared/immich/credentials".path;
        ingress.${publicHostname} = "http://127.0.0.1:2283";
        default = "http_status:404";
      };
    };
  };
}
