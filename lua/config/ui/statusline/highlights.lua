local colors = require("config.ui.colors")
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
    bg = colors.mantle,
  },
  StatusLine_DiagnosticsWarning = {
    fg = colors.yellow,
    bg = colors.mantle,
  },
  StatusLine_DiagnosticsHints = {
    fg = colors.sky,
    bg = colors.mantle,
  },
  StatusLine_DiagnosticsInfo = {
    fg = colors.yellow, --TODO
    bg = colors.mantle,
  },
  StatusLine_LspInfo = {
    fg = colors.lavender,
    bg = colors.mantle,
  },
  StatusLine_GitBranchSep = {
    fg = colors.green,
    bg = colors.mantle,
  },
  StatusLine_GitBranch = {
    fg = colors.base,
    bg = colors.teal,
  },
  StatusLine_Macro = {
    fg = colors.mauve,
    bg = colors.mantle,
  },
}
