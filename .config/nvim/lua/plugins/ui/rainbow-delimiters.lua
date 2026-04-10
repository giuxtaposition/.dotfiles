return {
  "HiPhish/rainbow-delimiters.nvim",
  opts = {},
  config = function(_, opts)
    require("rainbow-delimiters.setup").setup(opts)
  end,
}
