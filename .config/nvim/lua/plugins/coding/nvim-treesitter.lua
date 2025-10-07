return {
  -- Highlight, edit, and navigate code.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    version = false,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          -- Avoid the sticky context from growing a lot.
          max_lines = 3,
          -- Match the context lines to the source code.
          multiline_threshold = 1,
          -- Disable it when the window is too small.
          min_window_height = 20,
        },
      },
    },
    opts = {
      ensure_installed = {
        "yaml",
        "graphql",
        "dockerfile",
        "gitignore",
        "c",
        "java",
        "kotlin",
        "diff",
        "http",
        "regex",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  -- Better text objects.
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local miniai = require("mini.ai")

      return {
        n_lines = 300,
        custom_textobjects = {
          f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          -- Whole buffer.
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
        -- Disable error feedback.
        silent = true,
        -- Don't use the previous or next text object.
        search_method = "cover",
        mappings = {
          -- Disable next/last variants.
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
        },
      }
    end,
  },
}
