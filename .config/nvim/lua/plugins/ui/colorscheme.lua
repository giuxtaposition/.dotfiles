vim.pack.add({
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
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

      RenderMarkdownBullet = { fg = palette.green },
      RenderMarkdownCode = { bg = palette.base },
      RenderMarkdownCodeBorder = { bg = palette.surface1 },
      RenderMarkdownTableHead = { fg = palette.mauve },
      RenderMarkdownTableRow = { fg = palette.mauve },

      ["@markup.heading.1.markdown"] = { link = "MiniStatusLineModeNormal" },
      ["@markup.heading.2.markdown"] = { link = "MiniStatusLineModeInsert" },
      ["@markup.heading.3.markdown"] = { link = "MiniStatusLineModeReplace" },
      ["@markup.heading.4.markdown"] = { link = "MiniStatusLineModeVisual" },
      ["@markup.heading.5.markdown"] = { link = "MiniStatusLineModeCommand" },
      ["@markup.heading.6.markdown"] = { link = "MiniStatusLineModeOther" },
      ["@markup.strong"] = { fg = palette.green, bold = true },
      ["@markup.italic"] = { fg = palette.green, italic = true },
    }

    return groups
  end,
  show_end_of_buffer = true,
  dim_inactive = {
    enabled = true,
  },
  integrations = {
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
    which_key = true,
    markview = true,
  },
})

vim.cmd([[colorscheme catppuccin]])
