vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
  },
  {
    src = "https://github.com/tpope/vim-fugitive",
  },
  {
    src = "https://github.com/sindrets/diffview.nvim",
  },
})

local icons = require("config.ui.icons")

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

local actions = require("diffview.actions")

require("diffview").setup({
  default_args = {
    DiffviewOpen = { "--imply-local" },
  },
  icons = {
    folder_closed = icons.file_system.folder.default,
    folder_open = icons.file_system.folder.open,
  },
  signs = {
    fold_closed = icons.arrows.right,
    fold_open = icons.arrows.down,
    done = "",
  },
  keymaps = {
    disable_defaults = true,
    view = {
      {
        "n",
        "<tab>",
        actions.select_next_entry,
        { desc = "Open the diff for the next file" },
      },
      {
        "n",
        "<s-tab>",
        actions.select_prev_entry,
        { desc = "Open the diff for the previous file" },
      },
      {
        "n",
        "[x",
        actions.prev_conflict,
        { desc = "Merge-tool: jump to the previous conflict" },
      },
      {
        "n",
        "]x",
        actions.next_conflict,
        { desc = "Merge-tool: jump to the next conflict" },
      },
      { "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      {
        "n",
        "<leader>Go",
        actions.conflict_choose("ours"),
        { desc = "Choose the OURS version of a conflict" },
      },
      {
        "n",
        "<leader>Gt",
        actions.conflict_choose("theirs"),
        { desc = "Choose the THEIRS version of a conflict" },
      },
      {
        "n",
        "<leader>Gb",
        actions.conflict_choose("base"),
        { desc = "Choose the BASE version of a conflict" },
      },
      {
        "n",
        "<leader>Ga",
        actions.conflict_choose("all"),
        { desc = "Choose all the versions of a conflict" },
      },
      { "n", "<leader>Gd", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
      {
        "n",
        "<leader>GO",
        actions.conflict_choose_all("ours"),
        { desc = "Choose the OURS version of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GT",
        actions.conflict_choose_all("theirs"),
        { desc = "Choose the THEIRS version of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GB",
        actions.conflict_choose_all("base"),
        { desc = "Choose the BASE version of a conflict for the whole file" },
      },
      unpack(actions.compat.fold_cmds),
    },
    diff2 = {
      { "n", "?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
    },
    diff3 = {
      { "n", "?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
    },
    file_panel = {
      {
        "n",
        "j",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "k",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry" },
      },
      {
        "n",
        "<cr>",
        actions.select_entry,
        { desc = "Open the diff for the selected entry" },
      },
      {
        "n",
        "s",
        actions.toggle_stage_entry,
        { desc = "Stage / unstage the selected entry" },
      },
      { "n", "S", actions.stage_all, { desc = "Stage all entries" } },
      { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
      {
        "n",
        "X",
        actions.restore_entry,
        { desc = "Restore entry to the state on the left side" },
      },
      { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
      { "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
      { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
      { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
      { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
      { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
      {
        "n",
        "<tab>",
        actions.select_next_entry,
        { desc = "Open the diff for the next file" },
      },
      {
        "n",
        "<s-tab>",
        actions.select_prev_entry,
        { desc = "Open the diff for the previous file" },
      },
      {
        "n",
        "i",
        actions.listing_style,
        { desc = 'Toggle between "list" and "tree" views' },
      },
      { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
      { "n", "?", actions.help("file_panel"), { desc = "Open the help panel" } },
      {
        "n",
        "<leader>GO",
        actions.conflict_choose_all("ours"),
        { desc = "Choose the OURS version of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GT",
        actions.conflict_choose_all("theirs"),
        { desc = "Choose the THEIRS version of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GB",
        actions.conflict_choose_all("base"),
        { desc = "Choose the BASE version of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GA",
        actions.conflict_choose_all("all"),
        { desc = "Choose all the versions of a conflict for the whole file" },
      },
      {
        "n",
        "<leader>GD",
        actions.conflict_choose_all("none"),
        { desc = "Delete the conflict region for the whole file" },
      },
    },
    file_history_panel = {
      { "n", "!", actions.options, { desc = "Open the option panel" } },
      {
        "n",
        "<leader>d",
        actions.open_in_diffview,
        { desc = "Open the entry under the cursor in a diffview" },
      },
      {
        "n",
        "y",
        actions.copy_hash,
        { desc = "Copy the commit hash of the entry under the cursor" },
      },
      { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
      {
        "n",
        "X",
        actions.restore_entry,
        { desc = "Restore file to the state from the selected entry" },
      },
      { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
      { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
      { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
      {
        "n",
        "j",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "k",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry" },
      },
      {
        "n",
        "<cr>",
        actions.select_entry,
        { desc = "Open the diff for the selected entry" },
      },
      { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
      { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
      { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      {
        "n",
        "<s-tab>",
        actions.select_prev_entry,
        { desc = "Open the diff for the previous file" },
      },
      { "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      { "n", "?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
      { "n", "q", actions.close, { desc = "Close the panel" } },
      { "n", "?", actions.help("option_panel"), { desc = "Open the help panel" } },
    },
    help_panel = {
      { "n", "q", actions.close, { desc = "Close help menu" } },
    },
  },
})

set_keymap("n", "<leader>gr", "<cmd>DiffviewFileHistory<cr>", "Repo History")
set_keymap("n", "<leader>gf", "<cmd>DiffviewFileHistory --follow %<cr>", "File history")
set_keymap("v", "<leader>gl", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", "Range history")
set_keymap("n", "<leader>gl", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", "Line history")
set_keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", "Repo Diff")
