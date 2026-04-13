# Paperless-ngx — Document Management System
#
# NixOS manages the PostgreSQL database automatically.
# OCR configured for English + Italian.
{
  lib,
  config,
  ...
}: {
  options = {paperless.enable = lib.mkEnableOption "Paperless-ngx document management";};

  config = lib.mkIf config.paperless.enable {
    services.paperless = {
      enable = true;
      port = 28981;
      mediaDir = "/media/paperless/media";
      consumptionDir = "/media/paperless/consume";

      settings = {
        PAPERLESS_OCR_LANGUAGE = "eng+ita";
        PAPERLESS_CONSUMER_RECURSIVE = "true";
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = "true";
      };
    };

    users.users.paperless.extraGroups = ["media"];

    networking.firewall.allowedTCPPorts = [28981];

    systemd.tmpfiles.rules = [
      "d /media/paperless 0770 paperless media - -"
      "d /media/paperless/media 0770 paperless media - -"
      "d /media/paperless/consume 0770 paperless media - -"
      "d /media/paperless/export 0770 paperless media - -"
    ];
  };
}
