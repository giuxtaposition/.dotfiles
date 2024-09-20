return {
  "dmmulroy/tsc.nvim",
  opts = {
    use_trouble_qflist = true,
    auto_close_qflist = true,
  },
  config = function(_, opts)
    require("tsc").setup(opts)
  end,
}
