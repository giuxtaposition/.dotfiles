return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
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
      { "<leader>zg", "<cmd>ZkNotes<cr>", desc = "Search Notes" },
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
