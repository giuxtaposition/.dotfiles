vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin-nvim",
  },
})

require("catppuccin").setup({
  flavour = "mocha",
  custom_highlights = function(palette)
    local groups = {
      FzfLuaPreviewTitle = { fg = palette.base, bg = palette.green, bold = true },
      FzfLuaScrollBorderEmpty = { fg = palette.base, bg = palette.base },
      FzfLuaScrollBorderFull = { fg = palette.base, bg = palette.base },
      FzfLuaScrollFloatEmpty = { fg = palette.base, bg = palette.base },
      FzfLuaScrollFloatFull = { fg = palette.base, bg = palette.base },

      FloatBorder = { fg = palette.base },
      LspInlayHint = { fg = palette.surface2, bg = "NONE" },

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
    ufo = true,
    rainbow_delimiters = true,
    lsp_trouble = true,
    which_key = true,
    markview = true,
  },
})

vim.cmd([[colorscheme catppuccin]])
