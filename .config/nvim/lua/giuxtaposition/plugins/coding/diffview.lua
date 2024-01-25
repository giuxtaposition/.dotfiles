return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  opts = function()
    local actions = require("diffview.actions")
    return {
      keymaps = {
        view = {
          {
            "n",
            "<leader>gDo",
            actions.conflict_choose("ours"),
            { desc = "Choose the OURS version of a conflict" },
          },
          {
            "n",
            "<leader>gDt",
            actions.conflict_choose("theirs"),
            { desc = "Choose the THEIRS version of a conflict" },
          },
          {
            "n",
            "<leader>gDb",
            actions.conflict_choose("base"),
            { desc = "Choose the BASE version of a conflict" },
          },
          {
            "n",
            "<leader>gDa",
            actions.conflict_choose("all"),
            { desc = "Choose all the versions of a conflict" },
          },
          {
            "n",
            "<leader>gDO",
            actions.conflict_choose_all("ours"),
            { desc = "Choose the OURS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gDT",
            actions.conflict_choose_all("theirs"),
            { desc = "Choose the THEIRS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gDB",
            actions.conflict_choose_all("base"),
            { desc = "Choose the BASE version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gDA",
            actions.conflict_choose_all("all"),
            { desc = "Choose all the versions of a conflict for the whole file" },
          },
          { "n", "<leader>gDd", actions.toggle_files, { desc = "Toggle the file panel." } },

          -- Disable these default keymaps
          ["<leader>co"] = false,
          ["<leader>ct"] = false,
          ["<leader>cb"] = false,
          ["<leader>ca"] = false,
          ["<leader>cO"] = false,
          ["<leader>cT"] = false,
          ["<leader>cB"] = false,
          ["<leader>cA"] = false,
          ["<leader>b"] = false,
        },
      },
    }
  end,
  keys = {
    {
      "<leader>gd",
      function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd("DiffviewOpen")
        else
          vim.cmd("DiffviewClose")
        end
      end,
      desc = "DiffView Toggle",
    },
    {
      "<leader>ghd",
      "<cmd>DiffviewFileHistory %<CR>",
      desc = "Diff current file",
    },
    {
      "<leader>ghD",
      "<cmd>DiffviewFileHistory<CR>",
      desc = "Diff current branch",
    },
  },
}
