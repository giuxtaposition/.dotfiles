vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
  },
  {
    src = "https://github.com/tpope/vim-fugitive",
  },
  {
    src = "https://github.com/esmuellert/codediff.nvim",
  },
})

local set_keymap = require("config.util.keys").set

local signs = require("config.ui.icons").gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = signs.add },
    change = { text = signs.change },
    delete = { text = signs.delete },
    topdelete = { text = signs.topdelete },
    changedelete = { text = signs.changedelete },
    untracked = { text = signs.untracked },
  },
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    map("n", "]h", gs.next_hunk, "Next Hunk")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
})

require("codediff").setup()

set_keymap("n", "<leader>gr", "<cmd>CodeDiff history<cr>", "Repo History")
set_keymap("n", "<leader>gf", "<cmd>CodeDiff history %<cr>", "File history")
set_keymap("v", "<leader>gl", "<esc><cmd>'<,'>CodeDiff history<cr>", "Visual Range history")
set_keymap("n", "<leader>gl", "<cmd>'<,'>CodeDiff history<cr>", "Line history")
set_keymap("n", "<leader>gd", "<cmd>CodeDiff<cr>", "Repo Diff")
