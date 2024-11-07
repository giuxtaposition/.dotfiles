local colors = require("config.ui.colors")

local statusline_bg = colors.mantle

return {
  StatusLine_NormalMode = {
    fg = colors.base,
    bg = colors.lavender,
    bold = true,
  },
  StatusLine_VisualMode = {
    fg = colors.base,
    bg = colors.mauve,
    bold = true,
  },
  StatusLine_InsertMode = {
    fg = colors.base,
    bg = colors.green,
    bold = true,
  },
  StatusLine_TerminalMode = {
    fg = colors.base,
    bg = colors.green,
    bold = true,
  },
  StatusLine_ReplaceMode = {
    fg = colors.base,
    bg = colors.red,
    bold = true,
  },
  StatusLine_SelectMode = {
    fg = colors.base,
    bg = colors.peach, --TODO
    bold = true,
  },
  StatusLine_CommandMode = {
    fg = colors.base,
    bg = colors.peach,
    bold = true,
  },
  StatusLine_ConfirmMode = {
    fg = colors.base,
    bg = colors.peach, --TODO
    bold = true,
  },
  StatusLine_NormalModeSep = {
    fg = colors.blue,
    bg = colors.surface2,
  },
  StatusLine_VisualModeSep = {
    fg = colors.mauve,
    bg = colors.surface2,
  },
  StatusLine_InsertModeSep = {
    bg = colors.surface2,
    fg = colors.green,
  },
  StatusLine_TerminalModeSep = {
    bg = colors.surface2,
    fg = colors.green,
  },
  StatusLine_ReplaceModeSep = {
    bg = colors.surface2,
    fg = colors.red,
  },
  StatusLine_SelectModeSep = {
    bg = colors.surface2,
    fg = colors.peach, --TODO
  },
  StatusLine_CommandModeSep = {
    bg = colors.surface2,
    fg = colors.peach,
  },
  StatusLine_ConfirmModeSep = {
    bg = colors.surface2,
    fg = colors.peach, --TODO
  },
  StatusLine_DiagnosticsError = {
    fg = colors.red,
    bg = statusline_bg,
  },
  StatusLine_DiagnosticsWarning = {
    fg = colors.yellow,
    bg = statusline_bg,
  },
  StatusLine_DiagnosticsHints = {
    fg = colors.sky,
    bg = statusline_bg,
  },
  StatusLine_DiagnosticsInfo = {
    fg = colors.yellow, --TODO
    bg = statusline_bg,
  },
  StatusLine_LspInfo = {
    fg = colors.lavender,
    bg = statusline_bg,
  },
  StatusLine_GitBranchSep = {
    fg = colors.green,
    bg = statusline_bg,
  },
  StatusLine_GitBranch = {
    fg = colors.base,
    bg = colors.teal,
  },
  StatusLine_Macro = {
    fg = colors.mauve,
    bg = statusline_bg,
  },
  StatusLine_FileIconRed = {
    fg = colors.red,
    bg = statusline_bg,
  },
  StatusLine_FileIconBlue = {
    fg = colors.blue,
    bg = statusline_bg,
  },
  StatusLine_FileIconCyan = {
    fg = colors.sky,
    bg = statusline_bg,
  },
  StatusLine_FileIconGrey = {
    fg = colors.text,
    bg = statusline_bg,
  },
  StatusLine_FileIconAzure = {
    fg = colors.sapphire,
    bg = statusline_bg,
  },
  StatusLine_FileIconGreen = {
    fg = colors.green,
    bg = statusline_bg,
  },
  StatusLine_FileIconOrange = {
    fg = colors.orange,
    bg = statusline_bg,
  },
  StatusLine_FileIconPurple = {
    fg = colors.mauve,
    bg = statusline_bg,
  },
  StatusLine_FileIconYellow = {
    fg = colors.yellow,
    bg = statusline_bg,
  },
  StatusLine_TypedKey = {
    fg = colors.blue,
    bg = statusline_bg,
  },
}
