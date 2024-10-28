return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    -- open_mapping = [[<leader>ft]],
    size = 15,
    hide_numbers = true,
    autochdir = true, -- auto change dir following neovim
    insert_mappings = false, -- whether or not the open mapping applies in insert mode
    float_opts = {
      width = 160,
      height = 40,
    },
    highlights = {
      FloatBorder = {
        guifg = require("config.ui.colors").base,
      },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      float_opts = {
        border = "curved",
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
    })

    function _Lazygit_toggle()
      lazygit:toggle()
    end
  end,
  keys = {
    { "<leader>fh", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal" },
    { "<leader>fv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
    { "<leader>gg", "<cmd>lua _Lazygit_toggle()<CR>", desc = "Lazygit Terminal" },
  },
}
