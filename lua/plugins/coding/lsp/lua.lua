return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { plugins = { "nvim-dap-ui" }, types = true },
      },
    },
  },
  { "gonstoll/wezterm-types", lazy = true },
  { "Bilal2453/luvit-meta", lazy = true },
}
