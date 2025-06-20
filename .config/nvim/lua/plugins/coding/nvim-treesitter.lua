return {
  -- Highlight, edit, and navigate code.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
        keys = {
          {
            "[c",
            function()
              -- Jump to previous change when in diffview.
              if vim.wo.diff then
                return "[c"
              else
                vim.schedule(function()
                  require("treesitter-context").go_to_context()
                end)
                return "<Ignore>"
              end
            end,
            desc = "Jump to upper context",
            expr = true,
          },
        },
      },
    },
    opts = {
      ensure_installed = {
        "json5",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "dockerfile",
        "gitignore",
        "nix",
        "svelte",
        "vue",
        "c",
        "java",
        "kotlin",
        "diff",
        "http",
        "regex",
        "ruby",
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
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- Better text objects.
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
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
