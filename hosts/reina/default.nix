{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "Reina";

  avahi.enable = true;
  docker.enable = true;
  steam.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  llama-server = {
    enable = true;
    # Set to a GGUF path once downloaded. Example:
    # model = "/var/lib/llama-server/models/qwen3.6-35b-a3b-coding-q4_K_M.gguf";
    modelUrl = "https://huggingface.co/SC117/Ornith-1.5-35B-A3B-Heretic-MTP-APEX-GGUF/resolve/main/Ornith-1.5-35B-A3B-Heretic-MTP-APEX-I-Compact.gguf";
    modelHash = "sha256-N/Z4YTyl79cbI84cOBHajY8HfHm+BZEE17IWU5vb4Oc=";
    alias = "Ornith-1.5-35B-A3B-Compact";
    # All non-expert layers on GPU; MoE experts stay on CPU. Much better
    # VRAM utility than splitting by layer index for MoE models.
    nGpuLayers = 999;
    nCpuMoe = 30;
    ctxSize = 32768;
    # Qwen3-family thinking-mode sampler.
    extraFlags = [
      "--jinja"
      "--flash-attn"
      "auto"
      "--temp"
      "0.6"
      "--top-p"
      "0.95"
      "--top-k"
      "20"
      "--min-p"
      "0"
    ];
  };
  work.enable = true;
  brightness-control-desktop.enable = true;

  hardware = {
    keyboard = {qmk.enable = true;};
  };

  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
