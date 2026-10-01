{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.llama-server;
  fetchedModel =
    if cfg.modelUrl != null
    then
      pkgs.fetchurl {
        url = cfg.modelUrl;
        hash = cfg.modelHash;
      }
    else null;
  modelPath =
    if cfg.model != null
    then cfg.model
    else if fetchedModel != null
    then "${fetchedModel}"
    else throw "llama-server: set either `model` (local GGUF path) or `modelUrl` + `modelHash`.";
in {
  options.llama-server = {
    enable = lib.mkEnableOption "local llama.cpp server with ROCm";

    model = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute path to a locally managed GGUF file. Mutually exclusive with `modelUrl`.";
      example = "/var/lib/llama-server/models/qwen3.6-35b-a3b-coding.gguf";
    };

    modelUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "HTTPS URL to a GGUF file. Fetched via Nix into /nix/store, no manual download needed.";
      example = "https://huggingface.co/SC117/Ornith-1.5-35B-A3B-Heretic-MTP-APEX-GGUF/resolve/main/Ornith-1.5-35B-A3B-Heretic-MTP-APEX-I-Compact.gguf";
    };

    modelHash = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "SRI hash (sha256-...) of the file at `modelUrl`. Use `lib.fakeHash` on first build; Nix will print the real hash to substitute.";
      example = "sha256-0000000000000000000000000000000000000000000=";
    };

    alias = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Model name reported by the OpenAI API (helps clients show a friendly name).";
    };

    nGpuLayers = lib.mkOption {
      type = lib.types.int;
      default = 999;
      description = "Layers to offload to GPU (999 = all). With nCpuMoe set, this stays 999 and MoE experts spill to CPU instead.";
    };

    nCpuMoe = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "MoE expert blocks kept on CPU. 0 = disabled (dense model). For a 35B-A3B MoE on 8 GB VRAM, ~30 is a reasonable start.";
    };

    ctxSize = lib.mkOption {
      type = lib.types.int;
      default = 16384;
    };

    batchSize = lib.mkOption {
      type = lib.types.int;
      default = 2048;
      description = "llama.cpp logical batch size. Larger = faster prompt processing.";
    };

    uBatchSize = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "llama.cpp micro-batch size. 2048+ speeds prompt processing at VRAM cost.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };

    metrics = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Expose Prometheus-style /metrics endpoint.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra flags passed to llama-server (e.g. sampler tuning, --jinja).";
      example = ["--jinja" "--temp" "0.6"];
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.llama-server = {
      isSystemUser = true;
      group = "llama-server";
      home = "/var/lib/llama-server";
      createHome = true;
    };
    users.groups.llama-server = {};

    environment.systemPackages = [pkgs.unstable.llama-cpp-rocm];

    systemd.services.llama-server = {
      description = "llama.cpp OpenAI-compatible inference server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        # RX 7600 (Navi 33, gfx1102) uses gfx1100 ROCm kernels via override.
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        HOME = "/var/lib/llama-server";
      };

      serviceConfig = {
        User = "llama-server";
        Group = "llama-server";
        WorkingDirectory = "/var/lib/llama-server";
        Restart = "on-failure";
        RestartSec = 5;

        MemoryHigh = "16G";
        MemoryMax = "20G";
        CPUQuota = "800%";
        Nice = 5;
        IOWeight = 50;

        ExecStart = lib.concatStringsSep " " (
          [
            "${pkgs.unstable.llama-cpp-rocm}/bin/llama-server"
            "--model ${modelPath}"
            "--host ${cfg.host}"
            "--port ${toString cfg.port}"
            "--n-gpu-layers ${toString cfg.nGpuLayers}"
            "--ctx-size ${toString cfg.ctxSize}"
            "--batch-size ${toString cfg.batchSize}"
            "--ubatch-size ${toString cfg.uBatchSize}"
          ]
          ++ lib.optionals (cfg.alias != null) ["--alias ${cfg.alias}"]
          ++ lib.optionals (cfg.nCpuMoe > 0) ["--n-cpu-moe ${toString cfg.nCpuMoe}"]
          ++ lib.optionals cfg.metrics ["--metrics"]
          ++ cfg.extraFlags
        );
      };
    };
  };
}
