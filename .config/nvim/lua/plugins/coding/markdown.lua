vim.pack.add({
  {
    src = "https://github.com/OXY2DEV/markview.nvim",
  },
  {
    src = "https://github.com/HakonHarnes/img-clip.nvim",
  },
  {
    src = "https://github.com/folke/snacks.nvim",
  },
  {
    src = "https://github.com/zk-org/zk-nvim",
  },
})

local set_keymap = require("config.util.keys").set

local presets = require("markview.presets")
require("markview").setup({
  markdown = {
    headings = vim.tbl_deep_extend("keep", {
      heading_1 = { sign = "" },
      heading_2 = { sign = "" },
      heading_3 = { sign = "" },
      heading_4 = { sign = "" },
      heading_5 = { sign = "" },
      heading_6 = { sign = "" },
    }, presets.headings.glow),
    horizontal_rules = presets.horizontal_rules.dotted,
  },
})

require("snacks").setup({
  styles = {
    -- INFO: show top right of screen
    snacks_image = {
      relative = "editor",
      col = -1,
    },
  },
  image = {
    enabled = true,
    doc = {
      max_width = 45,
      max_height = 20,
    },
  },
})

require("zk").setup({
  picker = "fzf_lua",
})

require("img-clip").setup({
  default = {
    dir_path = "notes/assets",
  },
})

set_keymap("n", "<leader>xt", "<cmd>TodoQuickFix<cr>", "Todo (QuickFix)")
set_keymap("n", "<leader>zg", "<cmd>ZkNotes { dir = 'notes'}<cr>", "Search Notes")
set_keymap("n", "<leader>zt", "<cmd>ZkTags { dir = 'notes'}<cr>", "Search Tags")
set_keymap("n", "<leader>zl", "<cmd>'<'>ZkInsertLinkAtSelection {matchSelected = true}<cr>", "Add link at selection")
set_keymap("n", "<leader>zw", "<cmd>ZkNotes { dir = 'work'}<cr>", "Search Work Notes")
set_keymap("n", "<leader>zj", "<cmd>ZkNotes { tags = { 'daily' }}<cr>", "Search Daily Notes")
set_keymap("n", "<leader>zn", function()
  vim.ui.input({ prompt = "Title: " }, function(title)
    require("zk.commands").get("ZkNew")({ dir = "notes", title = title })
  end)
end, "Create a new note")
set_keymap("n", "<leader>zq", function()
  vim.ui.input({ prompt = "Title: " }, function(title)
    require("zk.commands").get("ZkNew")({ dir = "work", title = title })
  end)
end, "Create a new work note")
set_keymap("n", "<leader>zr", "<cmd>ZkNotes { dir = 'notes', sort = { 'modified'} }<cr>", "Most recent notes")
set_keymap("n", "<leader>pi", "<cmd>PasteImage<cr>", "Paste image from system clipboard")
