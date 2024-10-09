return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      custom_highlights = function(palette)
        return {
          ["BlinkCmpMenu"] = {
            fg = palette.overlay0,
          },
          ["BlinkCmpLabel"] = {
            fg = palette.overlay0,
          },
          ["BlinkCmpMenuBorder"] = {
            fg = palette.lavender,
          },
          ["BlinkCmpDocBorder"] = {
            fg = palette.lavender,
          },
          ["BlinkCmpSignatureHelpBorder"] = {
            fg = palette.lavender,
          },
          ["BlinkCmpMenuSelection"] = {
            bg = palette.surface0,
          },
        }
      end,
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = true,
      },
      -- transparent_background = true,
      integrations = {
        --TODO cleanup unused
        dashboard = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          scope_color = "mauve",
          colored_indent_levels = false,
        },
        markdown = true,
        mini = {
          enabled = true,
          indentscope_color = "mauve",
        },
        neotree = true,
        neotest = true,
        noice = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "underline" },
            warnings = { "undercurl" },
            information = { "underline" },
          },
        },
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        rainbow_delimiters = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        lsp_trouble = true,
        which_key = true,
        render_markdown = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      -- load the colorscheme here
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
