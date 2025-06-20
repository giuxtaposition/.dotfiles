local colors = require("config.ui.colors")

return {
  StatusLine_NormalMode = {
    fg = colors.black0,
    bg = colors.purple0,
    bold = true,
  },
  StatusLine_VisualMode = {
    fg = colors.black0,
    bg = colors.pink,
    bold = true,
  },
  StatusLine_InsertMode = {
    fg = colors.black0,
    bg = colors.green,
    bold = true,
  },
  StatusLine_TerminalMode = {
    fg = colors.black0,
    bg = colors.green,
    bold = true,
  },
  StatusLine_ReplaceMode = {
    fg = colors.black0,
    bg = colors.red,
    bold = true,
  },
  StatusLine_SelectMode = {
    fg = colors.black0,
    bg = colors.orange,
    bold = true,
  },
  StatusLine_CommandMode = {
    fg = colors.black0,
    bg = colors.orange,
    bold = true,
  },
  StatusLine_ConfirmMode = {
    fg = colors.black0,
    bg = colors.orange,
    bold = true,
  },
  StatusLine_NormalModeSep = {
    fg = colors.blue,
    bg = colors.black2,
  },
  StatusLine_VisualModeSep = {
    fg = colors.pink,
    bg = colors.black2,
  },
  StatusLine_InsertModeSep = {
    bg = colors.black2,
    fg = colors.green,
  },
  StatusLine_TerminalModeSep = {
    bg = colors.black2,
    fg = colors.green,
  },
  StatusLine_ReplaceModeSep = {
    bg = colors.black2,
    fg = colors.red,
  },
  StatusLine_SelectModeSep = {
    bg = colors.black2,
    fg = colors.orange,
  },
  StatusLine_CommandModeSep = {
    bg = colors.black2,
    fg = colors.orange,
  },
  StatusLine_ConfirmModeSep = {
    bg = colors.black2,
    fg = colors.orange,
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
    fg = colors.purple0,
  },
  StatusLine_GitBranchSep = {
    fg = colors.green,
  },
  StatusLine_GitBranch = {
    fg = colors.black0,
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
    fg = colors.cyan,
  },
  StatusLine_FileIconGrey = {
    fg = colors.text,
  },
  StatusLine_FileIconAzure = {
    fg = colors.darkcyan,
  },
  StatusLine_FileIconGreen = {
    fg = colors.green,
  },
  StatusLine_FileIconOrange = {
    fg = colors.orange,
  },
  StatusLine_FileIconPurple = {
    fg = colors.pink,
  },
  StatusLine_FileIconYellow = {
    fg = colors.yellow,
  },
  StatusLine_TypedKey = {
    fg = colors.purple1,
  },
}
