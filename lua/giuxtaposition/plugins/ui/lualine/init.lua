return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local cpn = require("giuxtaposition.plugins.ui.lualine.components")
    local function draw(groups)
      if groups == nil then
        return
      end
      for group, value in pairs(groups) do
        vim.api.nvim_set_hl(0, group, value)
      end
    end

    local colors = require("giuxtaposition.config.colors")

    local highlights = {
      SLGitIcon = {
        bg = colors.bg_dark,
        fg = colors.yellow,
      },
      SLBranchName = {
        bg = colors.bg_dark,
        fg = colors.fg,
      },
      SLError = {
        bg = colors.bg_dark,
        fg = colors.red1,
      },
      SLWarning = {
        bg = colors.bg_dark,
        fg = colors.orange,
      },
      SLInfo = {
        bg = colors.bg_dark,
        fg = colors.cyan,
      },
      SLDiffAdd = {
        bg = colors.bg_dark,
        fg = colors.green,
      },
      SLDiffChange = {
        bg = colors.bg_dark,
        fg = colors.yellow,
      },
      SLDiffDelete = {
        bg = colors.bg_dark,
        fg = colors.red,
      },
      SLPosition = {
        bg = colors.bg_dark,
        fg = colors.magenta,
      },
      SLFiletype = {
        bg = colors.bg_dark,
        fg = colors.cyan,
      },
      SLShiftWidth = {
        bg = colors.bg_dark,
        fg = colors.yellow,
      },
      SLEncoding = {
        bg = colors.bg_dark,
        fg = colors.green,
      },
      SLModeNormal = {
        bg = colors.bg_dark,
        fg = colors.blue,
        bold = true,
      },
      SLModeInsert = {
        bg = colors.bg_dark,
        fg = colors.green,
        bold = true,
      },
      SLModeVisual = {
        bg = colors.bg_dark,
        fg = colors.magenta,
        bold = true,
      },
      ["SLModeV-Line"] = {
        bg = colors.bg_dark,
        fg = colors.magenta,
        bold = true,
      },
      SLModeCommand = {
        bg = colors.bg_dark,
        fg = colors.orange,
        bold = true,
      },
      SLModeReplace = {
        bg = colors.bg_dark,
        fg = colors.red,
        bold = true,
      },
      SLSeparatorUnused = {
        bg = colors.bg_dark,
        fg = "",
      },
      SLSeparator = {
        bg = colors.bg_dark,
        fg = "",
      },
      SLPadding = {
        bg = colors.bg_dark,
        fg = "",
      },
    }

    draw(highlights)

    return {
      options = {
        theme = "auto",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha" },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          -- winbar = 100,
        },
      },
      sections = {
        lualine_a = { cpn.branch },
        lualine_b = { cpn.diagnostics },
        lualine_c = {},
        lualine_x = { cpn.diff },
        lualine_y = { cpn.position, cpn.filetype },
        lualine_z = { cpn.spaces, cpn.mode },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {
        "nvim-tree",
      },
    }
  end,
}
