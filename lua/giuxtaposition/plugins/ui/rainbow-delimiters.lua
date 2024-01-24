return {

  "HiPhish/rainbow-delimiters.nvim",
  dependencies = "copilot.lua",
  opts = {},
  config = function(_, opts)
    require("rainbow-delimiters.setup").setup(opts)
  end,
}
