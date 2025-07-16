return {
  {
    "catppuccin/nvim",
    name = "catppuccin-nvim",
    priority = 1000,
    opts = {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          peach = "#ffb07c",
        },
      },
      custom_highlights = function(palette)
        local groups = {
          FzfLuaPreviewTitle = { fg = palette.base, bg = palette.green, bold = true },
          FzfLuaScrollBorderEmpty = { fg = palette.base, bg = palette.base },
          FzfLuaScrollBorderFull = { fg = palette.base, bg = palette.base },
          FzfLuaScrollFloatEmpty = { fg = palette.base, bg = palette.base },
          FzfLuaScrollFloatFull = { fg = palette.base, bg = palette.base },

          FloatBorder = { fg = palette.base },

          BlinkCmpMenu = { fg = palette.text, bg = palette.mantle },
          BlinkCmpMenuBorder = { fg = palette.mantle, bg = palette.mantle },
          BlinkCmpDocBorder = { fg = palette.crust, bg = palette.crust },
          BlinkCmpDoc = { fg = palette.text, bg = palette.crust },
          BlinkCmpKindCopilot = { fg = palette.sky },
        }

        return groups
      end,
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = true,
      },
      integrations = {
        blink_cmp = true,
        dashboard = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          scope_color = "mauve",
          colored_indent_levels = false,
        },
        mini = {
          enabled = true,
          indentscope_color = "mauve",
        },
        neotree = true,
        neotest = true,
        noice = true,
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
