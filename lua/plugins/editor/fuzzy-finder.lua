return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    winopts = {
      width = 0.9,
      backdrop = 60,
    },
    files = {
      prompt = "",
    },
  },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
  end,
  keys = {
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    {
      "<leader>fc",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "Find Config File",
    },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", desc = "Commits For Current Buffer" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>sf", "<cmd>FzfLua grep_cword<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "Find help tags" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "z=", "<Cmd>FzfLua spell_suggest<CR>", desc = "FzfLua: Find spell word suggestion" },
  },
}
