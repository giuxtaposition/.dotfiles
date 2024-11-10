return {
  "codethread/qmk.nvim",
  opts = {
    name = "Sweep layout",
    layout = {
      "x x x x x _ _ _ x x x x x",
      "x x x x x _ _ _ x x x x x",
      "x x x x x _ _ _ x x x x x",
      "_ _ _ _ x x _ x x _ _ _ _",
    },
    variant = "zmk",
  },
  config = function(_, opts)
    require("qmk").setup(opts)
  end,
}
