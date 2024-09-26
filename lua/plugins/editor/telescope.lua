return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        path_display = { "smart" },
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

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
  end,
  keys = {
    -- find
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "Find Config File",
    },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    {
      "<leader>sB",
      function()
        require("telescope.builtin").live_grep({ grep_open_files = true })
      end,
      desc = "Find string in open buffers",
    },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>sf", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },

    { "z=", "<Cmd>Telescope spell_suggest<CR>", desc = "Telescope: Find spell word suggestion" },
  },
}
