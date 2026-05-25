# Don't Starve Together dedicated server — Master + Caves shards
#
# Architecture:
#   dst-update   — oneshot: installs/updates server via steamcmd (app 343050)
#   dst-setup    — oneshot: copies generated configs + cluster token into dataDir
#   dst-master   — long-running: Master shard (overworld), port 10999
#   dst-caves    — long-running: Caves shard, port 11000
#
# Credentials:
#   Cluster token managed via sops-nix — decrypted at activation to /run/secrets/.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.dst-server;
  hasSecrets = builtins.pathExists ../../../secrets/secrets.yaml;
  # DST uses ${dataDir}/DoNotStarveTogether/ directly (no .klei prefix)
  # when -persistent_storage_root is passed; confirmed by PersistRootStorage log.
  clusterDir = "${cfg.dataDir}/DoNotStarveTogether/${cfg.clusterName}";
  serverDir = "${cfg.dataDir}/server";
  serverBin = "${serverDir}/bin64/dontstarve_dedicated_server_nullrenderer_x64";

  # DST was built against Debian's libcurl4-gnutls which adds CURL_GNUTLS_3
  # versioned symbols via a version script. NixOS's curlWithGnuTls doesn't
  # apply that script, so we rebuild it with the version script added.
  curlGnutls4 = let
    versionScript = pkgs.writeText "curl-gnutls.map" ''
      CURL_GNUTLS_3 {
        global: curl_*; CURL*;
      };
    '';
  in
    pkgs.curlWithGnuTls.overrideAttrs (old: {
      env =
        (old.env or {})
        // {
          LDFLAGS = (old.env.LDFLAGS or "") + " -Wl,--version-script=${versionScript}";
        };
    });

  dstRpath = lib.concatStringsSep ":" [
    "${curlGnutls4.out}/lib"
    "${pkgs.stdenv.cc.cc.lib}/lib"
    "${serverDir}/bin64/lib64"
  ];

  # Named pipes for injecting console commands (used by ExecStop to send
  # c_shutdown(true) which triggers a full world+user save before exit).
  masterPipe = "${cfg.dataDir}/master-console.fifo";
  cavesPipe = "${cfg.dataDir}/caves-console.fifo";

  backupDir = "${cfg.dataDir}/player-backups";

  deletePlayerScript = pkgs.writeShellApplication {
    name = "dst-delete-player";
    runtimeInputs = [pkgs.coreutils pkgs.bash];
    text = ''
      LOG_FILE="${clusterDir}/Master/server_log.txt"

      if [[ ! -f "$LOG_FILE" ]]; then
        echo "Log file not found: $LOG_FILE"
        exit 1
      fi

      declare -A USER_MAP=()
      while IFS= read -r line; do
        if [[ "$line" =~ Client\ authenticated:\ \(([A-Za-z0-9_]+)\)\ (.+) ]]; then
          ku_id="''${BASH_REMATCH[1]}"
          name="''${BASH_REMATCH[2]}"
          USER_MAP["$name"]="$ku_id"
        fi
      done < "$LOG_FILE"

      if [[ ''${#USER_MAP[@]} -eq 0 ]]; then
        echo "No players found."
        exit 1
      fi

      mapfile -t NAMES < <(printf '%s\n' "''${!USER_MAP[@]}" | sort)

      echo "Players found:"
      for i in "''${!NAMES[@]}"; do
        printf "  [%d] %s (%s)\n" "$((i+1))" "''${NAMES[$i]}" "''${USER_MAP[''${NAMES[$i]}]}"
      done

      echo
      read -rp "Pick number (or 0 to cancel): " choice

      if [[ "$choice" == "0" || -z "$choice" ]]; then
        echo "Cancelled."
        exit 0
      fi

      if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ''${#NAMES[@]} )); then
        echo "Invalid choice."
        exit 1
      fi

      selected="''${NAMES[$((choice-1))]}"
      ku_id="''${USER_MAP[$selected]}"

      echo
      echo "Delete data for: $selected ($ku_id)"
      read -rp "Confirm? [y/N] " confirm

      if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Cancelled."
        exit 0
      fi

      BACKUP_DEST="${backupDir}/''${ku_id}_$(date +%Y%m%d_%H%M%S)"
      mkdir -p "$BACKUP_DEST"

      deleted=0
      for shard in Master Caves; do
        session_dir=$(find "${clusterDir}/$shard/save/session" -maxdepth 2 -type d -name "''${ku_id}_" 2>/dev/null | head -n1)
        if [[ -n "$session_dir" ]]; then
          if cp -r "$session_dir" "$BACKUP_DEST/$shard"; then
            echo "Backed up: $session_dir -> $BACKUP_DEST/$shard"
          else
            echo "Warning: backup failed for $session_dir, deleting anyway"
          fi
          rm -rf "$session_dir"
          echo "Deleted: $session_dir"
          deleted=1
        fi
      done

      if [[ $deleted -eq 0 ]]; then
        rmdir "$BACKUP_DEST"
        echo "No session data found for $ku_id."
      else
        echo "Backup saved to: $BACKUP_DEST"
      fi
    '';
  };

  masterStopScript = pkgs.writeShellScript "dst-master-stop" ''
    if [ -p ${masterPipe} ]; then
      echo 'c_shutdown()' > ${masterPipe} || true
    fi

    sleep 15
  '';

  cavesStopScript = pkgs.writeShellScript "dst-caves-stop" ''
    if [ -p ${cavesPipe} ]; then
      echo 'c_shutdown()' > ${cavesPipe} || true
    fi

    sleep 15
  '';
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
      description = "Base directory for DST server data and binaries";
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

    sopsPasswordKey = lib.mkOption {
      type = lib.types.str;
      default = "dst/cluster_password";
      description = "Key in SOPS file for cluster password";
    };

    cluster = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "My DST Server";
        description = "Server name shown in the server browser";
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Server description shown in the server browser";
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

      # Shared secret used for Master↔Caves shard authentication.
      # Not sensitive — just needs to be identical across all shards.
      key = lib.mkOption {
        type = lib.types.str;
        default = "defaultclusterkey";
        description = "Shared cluster key for inter-shard authentication";
      };
    };

    mods = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          id = lib.mkOption {
            type = lib.types.str;
            description = "Steam Workshop item ID";
          };
          config = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Lua configuration_options table string, e.g. '{ key = \"val\" }'";
          };
        };
      });
      default = [];
      description = "Workshop mods to install and enable on all shards";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure primary group exists for the runtime user
    users.groups.${cfg.user} = {};

    users.users.${cfg.user} = {
      isSystemUser = true;
      description = "Don't Starve Together server user";
      createHome = false;
      group = cfg.user;
      home = cfg.dataDir;
    };

    environment.systemPackages = [deletePlayerScript];

    # ---- Open firewall ports ----
    # 10998 = inter-shard (loopback), 10999 = Master, 11000 = Caves
    networking.firewall.allowedUDPPorts = [10998 10999 11000];

    # ---- Generate cluster.ini ----
    environment.etc =
      {
        "dst/${cfg.clusterName}/cluster.ini".text = ''
          [GAMEPLAY]
          game_mode = ${cfg.cluster.gameMode}
          max_players = ${toString cfg.cluster.maxPlayers}
          pvp = ${
            if cfg.cluster.pvp
            then "true"
            else "false"
          }
          pause_when_empty = true

          [NETWORK]
          cluster_description = ${cfg.cluster.description}
          cluster_name = ${cfg.cluster.name}
          cluster_password = __DST_PASSWORD_PLACEHOLDER__

          [MISC]
          console_enabled = true
          max_snapshots = 10

          [SHARD]
          shard_enabled = true
          bind_ip = 127.0.0.1
          master_ip = 127.0.0.1
          master_port = 10998
          cluster_key = ${cfg.cluster.key}
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

        "dst/${cfg.clusterName}/Master/worldgenoverride.lua".source = ./worldgenoverride_master.lua;
        "dst/${cfg.clusterName}/Caves/worldgenoverride.lua".source = ./worldgenoverride_caves.lua;
      }
      // lib.optionalAttrs (cfg.mods != []) {
        "dst/mods_setup.lua".text =
          lib.concatMapStrings
          (mod: "ServerModSetup(\"${mod.id}\")\n")
          cfg.mods;

        "dst/${cfg.clusterName}/Master/modoverrides.lua".text = let
          modEntry = mod: ''            ["workshop-${mod.id}"] = { enabled = true${
              lib.optionalString (mod.config != "") ", configuration_options = ${mod.config}"
            } },
          '';
        in "return {\n${lib.concatMapStrings modEntry cfg.mods}}";

        "dst/${cfg.clusterName}/Caves/modoverrides.lua".text =
          config.environment.etc."dst/${cfg.clusterName}/Master/modoverrides.lua".text;
      };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${serverDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${cfg.dataDir}/DoNotStarveTogether 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir}/Master 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir}/Caves 0755 ${cfg.user} ${cfg.user} -"
      "d ${backupDir} 0755 ${cfg.user} ${cfg.user} -"
    ];

    systemd.services = {
      # ---- Install / update server binaries via steamcmd ----
      dst-update = {
        description = "DST server install/update";
        wantedBy = ["multi-user.target"];
        before = ["dst-master.service" "dst-caves.service"];
        after = ["network-online.target"];
        wants = ["network-online.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = cfg.user;
        };

        script = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${serverDir} \
            +login anonymous \
            +app_update 343050 validate \
            +quit

          # Patch the binary to use NixOS's dynamic linker and explicit rpath.
          # Re-run after every steamcmd update in case the binary was replaced.
          ORIG_RPATH=$(${pkgs.patchelf}/bin/patchelf --print-rpath ${serverBin} 2>/dev/null || true)
          ${pkgs.patchelf}/bin/patchelf \
            --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
            --set-rpath "${dstRpath}''${ORIG_RPATH:+:$ORIG_RPATH}" \
            ${serverBin}

          # Create the libcurl-gnutls.so.4 alias that DST expects.
          # Must use curlGnutls4 (rebuilt with CURL_GNUTLS_3 version script).
          ln -sf ${curlGnutls4.out}/lib/libcurl.so.4 \
            ${serverDir}/bin64/lib64/libcurl-gnutls.so.4
        '';
      };

      # ---- Copy configs into runtime dir ----
      dst-setup = {
        description = "DST config setup";
        wantedBy = ["multi-user.target"];
        before = ["dst-master.service" "dst-caves.service"];
        after = ["dst-update.service"];

        serviceConfig.Type = "oneshot";

        # Run as root: avoids permission issues when files already exist
        # owned by root from previous runs. Chowns everything at the end
        # so dst-master/caves (running as cfg.user) can read the configs.
        script = ''
          ${pkgs.coreutils}/bin/mkdir -p ${clusterDir}/Master ${clusterDir}/Caves

          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/cluster.ini ${clusterDir}/
          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Master/server.ini ${clusterDir}/Master/
          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Master/worldgenoverride.lua ${clusterDir}/Master/
          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Caves/server.ini ${clusterDir}/Caves/
          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Caves/worldgenoverride.lua ${clusterDir}/Caves/

          ${lib.optionalString (cfg.mods != []) ''
            ${pkgs.coreutils}/bin/cp /etc/dst/mods_setup.lua ${serverDir}/mods/dedicated_server_mods_setup.lua
            ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Master/modoverrides.lua ${clusterDir}/Master/
            ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Caves/modoverrides.lua ${clusterDir}/Caves/
          ''}

          # Inject cluster password from sops secret
          DST_PASSWORD=$(cat ${config.sops.secrets.${cfg.sopsPasswordKey}.path})
          ${pkgs.gnused}/bin/sed -i \
            "s|cluster_password = __DST_PASSWORD_PLACEHOLDER__|cluster_password = $DST_PASSWORD|" \
            ${clusterDir}/cluster.ini

          # Inject secret token
          ${pkgs.coreutils}/bin/cp ${config.sops.secrets.${cfg.sopsTokenKey}.path} \
            ${clusterDir}/cluster_token.txt

          ${pkgs.coreutils}/bin/chown -R ${cfg.user}:${cfg.user} ${cfg.dataDir}
        '';
      };

      # ---- Master shard (overworld) ----
      dst-master = {
        description = "DST Master shard";
        wantedBy = ["multi-user.target"];
        after = [
          "dst-setup.service"
          "dst-update.service"
          "network-online.target"
        ];
        wants = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${serverDir}/bin64";
          Restart = "always";
          RestartSec = "15s";
          ExecStop = "${masterStopScript}";
          KillMode = "control-group";
          TimeoutStopSec = 300;
          SuccessExitStatus = ["139" "SIGSEGV"];
        };

        environment.LD_LIBRARY_PATH = "${serverDir}/bin64/lib64";
        script = ''
          rm -f ${masterPipe}
          mkfifo ${masterPipe}
          exec 3<>${masterPipe}
          echo "Starting DST master shard..."
          ${serverBin} \
            -console \
            -persistent_storage_root ${cfg.dataDir} \
            -cluster ${cfg.clusterName} \
            -shard Master \
            <&3
          exec 3>&-
        '';
      };

      dst-caves = {
        description = "DST Caves shard";
        wantedBy = ["multi-user.target"];
        requires = ["dst-master.service"];
        after = [
          "dst-master.service"
          "dst-setup.service"
          "dst-update.service"
        ];
        bindsTo = ["dst-master.service"];
        partOf = ["dst-master.service"];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${serverDir}/bin64";
          Restart = "always";
          RestartSec = "15s";
          ExecStop = "${cavesStopScript}";
          KillMode = "control-group";
          TimeoutStopSec = 300;
          SuccessExitStatus = ["139" "SIGSEGV"];
        };

        environment.LD_LIBRARY_PATH = "${serverDir}/bin64/lib64";

        script = ''
          echo "Waiting for master shard networking..."

          for i in $(seq 1 90); do
            if ${pkgs.netcat}/bin/nc -z 127.0.0.1 10998; then
              echo "Master shard port is ready"
              break
            fi

            sleep 2
          done

          # Additional stabilization delay.
          # DST often binds the port before shard auth is fully ready.
          sleep 10
          rm -f ${cavesPipe}
          mkfifo ${cavesPipe}
          exec 3<>${cavesPipe}
          echo "Starting DST caves shard..."

          ${serverBin} \
            -console \
            -persistent_storage_root ${cfg.dataDir} \
            -cluster ${cfg.clusterName} \
            -shard Caves \
            <&3

          exec 3>&-
        '';
      };
    };

    # Cluster token and password secrets (only when secrets file exists)
    sops.secrets = lib.mkIf hasSecrets {
      ${cfg.sopsTokenKey}.owner = cfg.user;
      ${cfg.sopsPasswordKey}.owner = cfg.user;
    };
  };
}
