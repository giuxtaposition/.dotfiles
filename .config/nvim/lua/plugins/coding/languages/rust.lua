return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "mrcjkb/rustaceanvim",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require("rustaceanvim.neotest"),
      })
    end,
  },
}
