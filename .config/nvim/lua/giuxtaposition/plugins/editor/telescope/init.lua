return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-project.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          dynamic_preview_title = true,
          hl_result_eol = true,
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules" },
          winblend = 2,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          mappings = {
            n = {
              ["q"] = actions.close,
            },
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-q>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { "node_modules/*", ".git/" },
          },
          live_grep = {
            additional_args = function(_)
              return { "--hidden" }
            end,
            file_ignore_patterns = { "node_modules/*", ".git/" },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("project")
      require("telescope").load_extension("aerial")
    end,
    keys = function()
      local filesPicker = require("giuxtaposition.plugins.editor.telescope.picker").filesPicker

      return {
        -- find
        { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        {
          "<leader>fc",
          function()
            filesPicker({ picker = "find_files", options = { cwd = vim.fn.stdpath("config") } })
          end,
          desc = "Find Config File",
        },
        {
          "<leader>fn",
          function()
            filesPicker({ picker = "find_files", options = { cwd = "~/notes" } })
          end,
          desc = "Find Notes File",
        },
        {
          "<leader>ff",
          function()
            filesPicker({ picker = "find_files" })
          end,
          desc = "Fuzzy find files in cwd",
        },
        {
          "<leader>fo",
          "<cmd>Telescope oldfiles<cr>",
          desc = "Fuzzy find recent files",
        },
        { "<leader>fx", "<cmd>Telescope resume<cr>", desc = "Resume last telescope window" },
        {
          "<leader>fp",
          function()
            require("telescope").extensions.project.project()
          end,
          desc = "Project",
        },

        -- lsp
        {
          "<leader>cs",
          "<cmd>Telescope lsp_document_symbols<CR>",
          desc = "List LSP document symbols in the current workspace",
        },

        -- git
        { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

        -- search
        { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "List registers" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      }
    end,
  },
}
