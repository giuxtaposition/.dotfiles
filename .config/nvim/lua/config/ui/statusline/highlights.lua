local colors = require("config.ui.colors")

return {
  StatusLine_NormalMode = {
    fg = colors.crust,
    bg = colors.mauve,
    bold = true,
  },
  StatusLine_VisualMode = {
    fg = colors.crust,
    bg = colors.pink,
    bold = true,
  },
  StatusLine_InsertMode = {
    fg = colors.crust,
    bg = colors.green,
    bold = true,
  },
  StatusLine_TerminalMode = {
    fg = colors.crust,
    bg = colors.green,
    bold = true,
  },
  StatusLine_ReplaceMode = {
    fg = colors.crust,
    bg = colors.red,
    bold = true,
  },
  StatusLine_SelectMode = {
    fg = colors.crust,
    bg = colors.peach,
    bold = true,
  },
  StatusLine_CommandMode = {
    fg = colors.crust,
    bg = colors.peach,
    bold = true,
  },
  StatusLine_ConfirmMode = {
    fg = colors.crust,
    bg = colors.peach,
    bold = true,
  },
  StatusLine_NormalModeSep = {
    fg = colors.blue,
    bg = colors.mantle,
  },
  StatusLine_VisualModeSep = {
    fg = colors.pink,
    bg = colors.mantle,
  },
  StatusLine_InsertModeSep = {
    bg = colors.mantle,
    fg = colors.green,
  },
  StatusLine_TerminalModeSep = {
    bg = colors.mantle,
    fg = colors.green,
  },
  StatusLine_ReplaceModeSep = {
    bg = colors.mantle,
    fg = colors.red,
  },
  StatusLine_SelectModeSep = {
    bg = colors.mantle,
    fg = colors.peach,
  },
  StatusLine_CommandModeSep = {
    bg = colors.mantle,
    fg = colors.peach,
  },
  StatusLine_ConfirmModeSep = {
    bg = colors.mantle,
    fg = colors.peach,
  },
  StatusLine_DiagnosticsError = {
    fg = colors.red,
  },
  StatusLine_DiagnosticsWarning = {
    fg = colors.yellow,
  },
  StatusLine_DiagnosticsHints = {
    fg = colors.sky,
  },
  StatusLine_DiagnosticsInfo = {
    fg = colors.yellow,
  },
  StatusLine_LspInfo = {
    fg = colors.mauve,
  },
  StatusLine_GitBranchSep = {
    fg = colors.green,
  },
  StatusLine_GitBranch = {
    fg = colors.crust,
    bg = colors.green,
  },
  StatusLine_Macro = {
    fg = colors.pink,
  },
  StatusLine_FileIconRed = {
    fg = colors.red,
  },
  StatusLine_FileIconBlue = {
    fg = colors.blue,
  },
  StatusLine_FileIconCyan = {
    fg = colors.sky,
  },
  StatusLine_FileIconGrey = {
    fg = colors.text,
  },
  StatusLine_FileIconAzure = {
    fg = colors.teal,
  },
  StatusLine_FileIconGreen = {
    fg = colors.green,
  },
  StatusLine_FileIconOrange = {
    fg = colors.peach,
  },
  StatusLine_FileIconPurple = {
    fg = colors.pink,
  },
  StatusLine_FileIconYellow = {
    fg = colors.yellow,
  },
  StatusLine_TypedKey = {
    fg = colors.lavender,
  },
}
