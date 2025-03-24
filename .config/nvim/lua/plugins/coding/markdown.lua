return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
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
    opts = {},
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "ueberzug",
      integrations = {
        markdown = {
          only_render_image_at_cursor = true,
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
      { "<leader>zw", "<cmd>ZkNotes { dir = 'work'}<cr>", desc = "Search Work Notes" },
      { "<leader>zj", "<cmd>ZkNotes { tags = { 'daily' }}<cr>", desc = "Search Daily Notes" },
      { "<leader>zn", "<cmd>ZkNew { dir = 'notes' }<cr>", desc = "Create a new note" },
      { "<leader>zq", "<cmd>ZkNew { dir = 'work' }<cr>", desc = "Create a new work note" },
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
