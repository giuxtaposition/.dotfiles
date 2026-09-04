# Byparr — Cloudflare bypass proxy (FlareSolverr-compatible /v1 API)
#
# Drop-in replacement for FlareSolverr with a patched undetected-chromedriver
# that can solve current Cloudflare Turnstile challenges (which vanilla
# FlareSolverr times out on, e.g. kagane.to).
#
# Runs as a Podman container with its own network namespace, publishing
# port 8191 to 127.0.0.1 only. Consumers (Suwayomi, which is on host
# networking) reach it via http://127.0.0.1:8191 unchanged.
#
# Cannot use --network=host: Xvfb creates an abstract Unix socket in the
# net namespace, and sharing the host's namespace makes it fail to start
# ("Xvfb :99 exited immediately").
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

          ports = ["127.0.0.1:8191:8191"];

          extraOptions = [
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
