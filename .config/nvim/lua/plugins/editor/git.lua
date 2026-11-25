vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

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
  current_line_blame = true,
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
    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk")
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
})

-- Lazy-loaded: diffview deferred to first use
local diffview_loaded = false

local function ensure_diffview()
  if diffview_loaded then
    return
  end
  diffview_loaded = true
  vim.pack.add({ { src = "https://github.com/dlyongemallo/diffview-plus.nvim" } })
  require("diffview").setup()
end

local function diffview_cmd(cmd)
  return function()
    ensure_diffview()
    vim.cmd(cmd)
  end
end

vim.keymap.set("n", "<leader>gr", diffview_cmd("DiffviewFileHistory"), { desc = "Repo History", silent = true })
vim.keymap.set("n", "<leader>gf", diffview_cmd("DiffviewFileHistory %"), { desc = "File history", silent = true })
vim.keymap.set("n", "<leader>gd", diffview_cmd("DiffviewOpen"), { desc = "Repo Diff", silent = true })

vim.api.nvim_create_user_command("GdiffCard", function(opts)
  ensure_diffview()
  vim.cmd("DiffviewOpen " .. opts.args)
end, { nargs = 1 })
