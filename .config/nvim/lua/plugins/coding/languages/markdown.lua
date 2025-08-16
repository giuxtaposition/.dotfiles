vim.lsp.enable({
  "marksman",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = {
      "markdown",
      "markdown_inline",
    } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      checkbox = {
        custom = {
          migrated = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
          todo = { raw = "[-]", rendered = "󰄱 ", highlight = "RenderMarkdownError", scope_highlight = nil },
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      dir_path = "notes/assets",
    },
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
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
    },
  },
  {
    "zk-org/zk-nvim",
    opts = {
      picker = "fzf_lua",
    },
    config = function(_, opts)
      require("zk").setup(opts)
    end,

    keys = {
      { "<leader>zg", "<cmd>ZkNotes { dir = 'notes'}<cr>", desc = "Search Notes" },
      { "<leader>zt", "<cmd>ZkTags { dir = 'notes'}<cr>", desc = "Search Tags" },
      { "<leader>zl", "<cmd>'<'>ZkInsertLinkAtSelection {matchSelected = true}<cr>", desc = "Add link at selection" },
      { "<leader>zw", "<cmd>ZkNotes { dir = 'work'}<cr>", desc = "Search Work Notes" },
      { "<leader>zj", "<cmd>ZkNotes { tags = { 'daily' }}<cr>", desc = "Search Daily Notes" },
      {
        "<leader>zn",
        function()
          vim.ui.input({ prompt = "Title: " }, function(title)
            require("zk.commands").get("ZkNew")({ dir = "notes", title = title })
          end)
        end,
        desc = "Create a new note",
      },
      {
        "<leader>zq",
        function()
          vim.ui.input({ prompt = "Title: " }, function(title)
            require("zk.commands").get("ZkNew")({ dir = "work", title = title })
          end)
        end,
        desc = "Create a new work note",
      },
    },
  },
  -- Otter.nvim provides lsp features for code embedded in other documents (markdown)
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
