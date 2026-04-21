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
  hasSecrets = builtins.pathExists ../../secrets/secrets.yaml;
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

  # ExecStop scripts: write c_shutdown(true) to the shard's stdin pipe.
  # DST executes it in Lua → saves world+users → exits cleanly.
  masterStopScript = pkgs.writeShellScript "dst-master-stop" ''
    [ -p ${masterPipe} ] && echo 'c_shutdown(true)' > ${masterPipe} || true
  '';
  cavesStopScript = pkgs.writeShellScript "dst-caves-stop" ''
    [ -p ${cavesPipe} ] && echo 'c_shutdown(true)' > ${cavesPipe} || true
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

      # Shared secret used for Master↔Caves shard authentication.
      # Not sensitive — just needs to be identical across all shards.
      key = lib.mkOption {
        type = lib.types.str;
        default = "defaultclusterkey";
        description = "Shared cluster key for inter-shard authentication";
      };
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

    # ---- Open firewall ports ----
    # 10998 = inter-shard (loopback), 10999 = Master, 11000 = Caves
    networking.firewall.allowedUDPPorts = [10998 10999 11000];

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
        pause_when_empty = true

        [NETWORK]
        cluster_description = ${cfg.cluster.description}
        cluster_name = ${cfg.cluster.name}
        cluster_password = ${cfg.cluster.password}

        [MISC]
        console_enabled = true

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
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${serverDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${cfg.dataDir}/DoNotStarveTogether 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir} 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir}/Master 0755 ${cfg.user} ${cfg.user} -"
      "d ${clusterDir}/Caves 0755 ${cfg.user} ${cfg.user} -"
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
          ${pkgs.coreutils}/bin/cp /etc/dst/${cfg.clusterName}/Caves/server.ini ${clusterDir}/Caves/

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
        after = ["dst-setup.service" "dst-update.service"];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${serverDir}/bin64";
          Restart = "on-failure";
          RestartSec = "10s";
          # Send c_shutdown(true) via stdin pipe → DST saves world+users then exits.
          # KillMode=mixed: after ExecStop, systemd waits TimeoutStopSec for DST to
          # exit cleanly, then sends SIGTERM to the main process as a fallback.
          # This prevents orphan processes when the clean shutdown doesn't complete.
          ExecStop = "${masterStopScript}";
          KillMode = "mixed";
          TimeoutStopSec = 90;
        };

        # FMOD and other bundled libs are loaded via dlopen() which ignores
        # rpath — LD_LIBRARY_PATH is required for those to be found.
        environment.LD_LIBRARY_PATH = "${serverDir}/bin64/lib64";

        script = ''
          # Create stdin pipe for console command injection (e.g. c_shutdown).
          [ -p ${masterPipe} ] || mkfifo ${masterPipe}
          # Open FIFO read+write so the bash process always holds the read end
          # open — prevents ExecStop's write from blocking when DST closes stdin.
          exec 3<>${masterPipe}
          ${serverBin} \
            -console \
            -persistent_storage_root ${cfg.dataDir} \
            -cluster ${cfg.clusterName} \
            -shard Master \
            <&3
          exec 3>&-
        '';
      };

      # ---- Caves shard ----
      dst-caves = {
        description = "DST Caves shard";
        wantedBy = ["multi-user.target"];
        after = ["dst-setup.service" "dst-update.service" "dst-master.service"];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${serverDir}/bin64";
          Restart = "on-failure";
          RestartSec = "10s";
          ExecStop = "${cavesStopScript}";
          KillMode = "mixed";
          TimeoutStopSec = 90;
        };

        environment.LD_LIBRARY_PATH = "${serverDir}/bin64/lib64";

        script = ''
          [ -p ${cavesPipe} ] || mkfifo ${cavesPipe}
          exec 3<>${cavesPipe}
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

    # Cluster token secret (only when secrets file exists)
    sops.secrets.${cfg.sopsTokenKey} = lib.mkIf hasSecrets {
      owner = cfg.user;
    };
  };
}
