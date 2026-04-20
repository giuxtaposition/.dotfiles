# Don't Starve Together dedicated server — Master + Caves shards
#
# Architecture:
#   Two systemd services (dst-master, dst-caves) run the game server.
#   A oneshot dst-setup service copies generated configs and the
#   cluster token into the runtime directory before shards start.
#
# Credentials:
#   Cluster token managed via sops-nix — decrypted at activation to /run/secrets/.
{
  config,
  lib,
  ...
}: let
  cfg = config.services.dst-server;
  hasSecrets = builtins.pathExists ../../secrets/secrets.yaml;
  clusterDir = "${cfg.dataDir}/.klei/DoNotStarveTogether/${cfg.clusterName}";
in {
  options.services.dst-server = {
    enable = lib.mkEnableOption "Don't Starve Together dedicated server (Master + Caves)";

    user = lib.mkOption {
      type = lib.types.str;
      default = "steam";
      description = "User account to run the DST server";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/dst";
      description = "Base directory for DST server data";
    };

    clusterName = lib.mkOption {
      type = lib.types.str;
      default = "Cluster_1";
      description = "Name of the cluster directory";
    };

    sopsTokenKey = lib.mkOption {
      type = lib.types.str;
      default = "dst/cluster_token";
      description = "Key in SOPS file for cluster token";
    };

    cluster = {
      description = lib.mkOption {
        type = lib.types.str;
        default = "My DST Server";
      };

      password = lib.mkOption {
        type = lib.types.str;
        default = "";
      };

      maxPlayers = lib.mkOption {
        type = lib.types.int;
        default = 6;
      };

      gameMode = lib.mkOption {
        type = lib.types.str;
        default = "survival";
      };

      pvp = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure the runtime user exists so other modules (eg. sops) can
    # reference config.users.users.${cfg.user}.group during evaluation.
    # Keep this minimal: system user with the expected primary group.
    # Ensure primary group exists for the runtime user
    users.groups.${cfg.user} = {};

    users.users.${cfg.user} = {
      isSystemUser = true;
      description = "Don't Starve Together server user";
      createHome = false;
      # explicit primary group so config.users.users.<name>.group is defined
      group = cfg.user;
      # set a sensible home (not created) matching the data dir
      home = cfg.dataDir;
    };
    # ---- Generate cluster.ini ----
    environment.etc = {
      "dst/${cfg.clusterName}/cluster.ini".text = ''
        [GAMEPLAY]
        game_mode = ${cfg.cluster.gameMode}
        max_players = ${toString cfg.cluster.maxPlayers}
        pvp = ${
          if cfg.cluster.pvp
          then "true"
          else "false"
        }

        [NETWORK]
        cluster_description = ${cfg.cluster.description}
        cluster_name = ${cfg.cluster.description}
        cluster_password = ${cfg.cluster.password}

        [MISC]
        console_enabled = true

        [SHARD]
        shard_enabled = true
      '';

      # ---- Generate shard configs ----
      "dst/${cfg.clusterName}/Master/server.ini".text = ''
        [NETWORK]
        server_port = 10999

        [SHARD]
        is_master = true
      '';

      "dst/${cfg.clusterName}/Caves/server.ini".text = ''
        [NETWORK]
        server_port = 11000

        [SHARD]
        is_master = false
        name = Caves
      '';
    };

    # ---- Copy configs into runtime dir ----
    systemd.services = {
      dst-setup = {
        description = "DST config setup";
        wantedBy = ["multi-user.target"];
        before = ["dst-master.service" "dst-caves.service"];

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
        };

        script = ''
          mkdir -p ${clusterDir}/Master
          mkdir -p ${clusterDir}/Caves

          cp /etc/dst/${cfg.clusterName}/cluster.ini ${clusterDir}/
          cp /etc/dst/${cfg.clusterName}/Master/server.ini ${clusterDir}/Master/
          cp /etc/dst/${cfg.clusterName}/Caves/server.ini ${clusterDir}/Caves/

          # Inject secret token
          cp ${config.sops.secrets.${cfg.sopsTokenKey}.path} \
             ${clusterDir}/cluster_token.txt
        '';
      };

      dst-master.after = ["dst-setup.service"];
      dst-caves.after = ["dst-setup.service"];
    };

    # Cluster token secret (only when secrets file exists)
    sops.secrets.${cfg.sopsTokenKey} = lib.mkIf hasSecrets {
      owner = cfg.user;
    };
  };
}
