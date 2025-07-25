return {
  {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanion",
    keys = {
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "x" },
    },
    opts = function()
      local config = require("codecompanion.config").config

      local diff_opts = config.display.diff.opts
      table.insert(diff_opts, "context:99") -- Setting the context to a very large number disables folding.

      return {
        strategies = {
          inline = {
            keymaps = {
              accept_change = {
                modes = { n = "<leader>ay" },
                description = "Accept the suggested change",
              },
              reject_change = {
                modes = { n = "<leader>an" },
                description = "Reject the suggested change",
              },
            },
          },
        },
        display = {
          diff = { opts = diff_opts },
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = "<C-.>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-/>",
        },
      },
    },
  },
}
