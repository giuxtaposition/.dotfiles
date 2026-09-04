# Byparr — Cloudflare bypass proxy (FlareSolverr-compatible /v1 API)
#
# Drop-in replacement for FlareSolverr with a patched undetected-chromedriver
# that can solve current Cloudflare Turnstile challenges (which vanilla
# FlareSolverr times out on, e.g. kagane.to).
#
# Runs as a Podman container on host networking, listening on
# 127.0.0.1:8191 — same port FlareSolverr used, so consumers (Suwayomi)
# keep pointing at http://127.0.0.1:8191 unchanged.
{
  lib,
  config,
  ...
}: {
  options = {byparr.enable = lib.mkEnableOption "Byparr Cloudflare bypass proxy";};

  config = lib.mkIf config.byparr.enable {
    virtualisation = {
      podman.enable = lib.mkDefault true;
      oci-containers = {
        backend = lib.mkDefault "podman";
        containers.byparr = {
          image = "ghcr.io/thephaseless/byparr:latest";

          extraOptions = [
            "--network=host"
            "--shm-size=2g"
          ];

          environment = {
            TZ = "Europe/Rome";
            LOG_LEVEL = "info";
          };
        };
      };
    };
  };
}
