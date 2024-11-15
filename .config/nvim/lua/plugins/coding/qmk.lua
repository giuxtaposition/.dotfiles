return {
  "codethread/qmk.nvim",
  config = function()
    local group = vim.api.nvim_create_augroup("qmk-format", {})

    vim.api.nvim_create_autocmd("BufEnter", {
      desc = "Format simple keymap",
      group = group,
      pattern = "*/qmk_userspace/keyboards/splitkb/aurora/sweep/rev1/keymaps/giuxtaposition/keymap.c",
      callback = function()
        require("qmk").setup({
          name = "LAYOUT_split_3x5_2",
          layout = {
            "x x x x x _ _ _ x x x x x",
            "x x x x x _ _ _ x x x x x",
            "x x x x x _ _ _ x x x x x",
            "_ _ _ _ x x _ x x _ _ _ _",
          },
        })
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      desc = "Format overlap keymap",
      group = group,
      pattern = "splitkb_aurora_sweep.keymap",
      callback = function()
        vim.notify("zmk layout")
        require("qmk").setup({
          name = "Sweep layout",
          layout = {
            "x x x x x _ _ _ x x x x x",
            "x x x x x _ _ _ x x x x x",
            "x x x x x _ _ _ x x x x x",
            "_ _ _ _ x x _ x x _ _ _ _",
          },
          variant = "zmk",
        })
      end,
    })
  end,
}
