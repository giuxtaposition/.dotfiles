# Calibre content server — e-book library with web UI + OPDS
#
# Serves the three existing libraries under /media. The web UI has a library
# switcher; OPDS exposes one feed per library.
#
# Runs as giu:users because that owns the libraries. calibre-server writes to
# metadata.db (library edits, read progress), so a dedicated service user
# would mean chowning ~600 author directories away from giu for no gain.
#
# Reachable on port 8080 from the LAN, and from anywhere over Tailscale
# (tailscale0 is a trusted interface, see tailscale.nix).
{
  lib,
  config,
  ...
}: {
  options = {calibre.enable = lib.mkEnableOption "Calibre content server";};

  config = lib.mkIf config.calibre.enable {
    services.calibre-server = {
      enable = true;
      libraries = [
        "/media/Fiction Library"
        "/media/Non-Fiction Library"
        "/media/Fanfiction Library"
      ];
      user = "giu";
      group = "users";
      openFirewall = true; # Port 8080

      # Uploads, edits and deletes are refused for anonymous users, so the
      # server needs accounts. The account database is not managed by Nix;
      # leaving userDb unset keeps it at calibre's default location
      # (~/.config/calibre/server-users.sqlite for the service user), which is
      # also where `calibre-server --manage-users` writes with no extra flags:
      #   calibre-server --manage-users
      #
      # auth-mode is basic rather than the default auto (= digest over plain
      # HTTP): KOReader's OPDS client cannot do digest, luasocket has no
      # support for it. Basic sends the password base64-encoded, so this is
      # only acceptable because the server stays on the LAN and the tailnet.
      auth = {
        enable = true;
        mode = "basic";
      };
    };
  };
}
