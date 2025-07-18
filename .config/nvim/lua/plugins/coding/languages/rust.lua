return {
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        require("rustaceanvim.neotest"),
      },
    },
  },
}
