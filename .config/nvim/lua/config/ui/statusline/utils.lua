local icons = require("config.ui.icons")
local util = require("config.util").table

local M = {
  typed_key = "",
}

M.statusline_buffer = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.is_active_win = function()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

M.separators = { left = "", right = "" }

M.modes = {
  ["n"] = { "NORMAL", "Normal" },
  ["no"] = { "NORMAL (no)", "Normal" },
  ["nov"] = { "NORMAL (nov)", "Normal" },
  ["noV"] = { "NORMAL (noV)", "Normal" },
  ["noCTRL-V"] = { "NORMAL", "Normal" },
  ["niI"] = { "NORMAL i", "Normal" },
  ["niR"] = { "NORMAL r", "Normal" },
  ["niV"] = { "NORMAL v", "Normal" },
  ["nt"] = { "NTERMINAL", "NTerminal" },
  ["ntT"] = { "NTERMINAL (ntT)", "NTerminal" },

  ["v"] = { "VISUAL", "Visual" },
  ["vs"] = { "V-CHAR (Ctrl O)", "Visual" },
  ["V"] = { "V-LINE", "Visual" },
  ["Vs"] = { "V-LINE", "Visual" },
  [""] = { "V-BLOCK", "Visual" },

  ["i"] = { "INSERT", "Insert" },
  ["ic"] = { "INSERT (completion)", "Insert" },
  ["ix"] = { "INSERT completion", "Insert" },

  ["t"] = { "TERMINAL", "Terminal" },
  ["!"] = { "SHELL", "Terminal" },

  ["R"] = { "REPLACE", "Replace" },
  ["Rc"] = { "REPLACE (Rc)", "Replace" },
  ["Rx"] = { "REPLACEa (Rx)", "Replace" },
  ["Rv"] = { "V-REPLACE", "Replace" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "Replace" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "Replace" },

  ["s"] = { "SELECT", "Select" },
  ["S"] = { "S-LINE", "Select" },
  [""] = { "S-BLOCK", "Select" },

  ["c"] = { "COMMAND", "Command" },
  ["cv"] = { "COMMAND", "Command" },
  ["ce"] = { "COMMAND", "Command" },
  ["cr"] = { "COMMAND", "Command" },

  ["r"] = { "PROMPT", "Confirm" },
  ["rm"] = { "MORE", "Confirm" },
  ["r?"] = { "CONFIRM", "Confirm" },
  ["x"] = { "CONFIRM", "Confirm" },
}

--- @return string
M.filetype_icon = function()
  local icon = "󰈔"
  local icon_color = ""

  local devicons_present, devicons = pcall(require, "nvim-web-devicons")
  if devicons_present then
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local ft_icon, hl_group = devicons.get_icon(filename, extension, { default = true })
    icon = ft_icon or icon

    if hl_group then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hl_group })
      if ok and hl and hl.fg then
        icon_color = string.format("#%06x", hl.fg)

        -- define a highlight group for the icon dynamically
        vim.api.nvim_set_hl(0, "StatusLine_FileIcon", { fg = icon_color })
      end
    end
  end

  return icon
end

M.git_status = function()
  if not vim.b[M.statusline_buffer()].gitsigns_head or vim.b[M.statusline_buffer()].gitsigns_git_status then
    return ""
  end

  local git_status = vim.b[M.statusline_buffer()].gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and (icons.git.added .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and (icons.git.modified .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and (icons.git.removed .. git_status.removed) or ""

  return " " .. added .. changed .. removed
end

M.git_branch = function()
  if not M.is_active_win() then
    return ""
  end

  local branch = vim.b[M.statusline_buffer()].gitsigns_head
  if not branch then
    return ""
  end

  return icons.git.branch .. branch
end

M.diagnostics = function()
  local err_number = #vim.diagnostic.get(M.statusline_buffer(), { severity = vim.diagnostic.severity.ERROR })
  local warn_number = #vim.diagnostic.get(M.statusline_buffer(), { severity = vim.diagnostic.severity.WARN })
  local hints_number = #vim.diagnostic.get(M.statusline_buffer(), { severity = vim.diagnostic.severity.HINT })
  local info_number = #vim.diagnostic.get(M.statusline_buffer(), { severity = vim.diagnostic.severity.INFO })

  local err = (err_number and err_number > 0) and string.format(" %s %s", icons.diagnostics.error, err_number) or ""
  local warn = (warn_number and warn_number > 0) and string.format(" %s %s", icons.diagnostics.info, warn_number) or ""
  local hints = (hints_number and hints_number > 0) and string.format(" %s %s", icons.diagnostics.hint, hints_number)
    or ""
  local info = (info_number and info_number > 0) and string.format(" %s %s", icons.diagnostics.info, info_number) or ""

  return {
    err = err,
    warn = warn,
    hints = hints,
    info = info,
  }
end

M.lsp = function()
  if not M.is_active_win() then
    return ""
  end

  local clients = vim.tbl_filter(function(client)
    return client.name ~= "copilot"
  end, vim.lsp.get_clients({ bufnr = M.statusline_buffer() }))

  if next(clients) then
    return " ["
      .. table.concat(
        util.map(clients, function(c)
          return c.name
        end),
        ", "
      )
      .. "]"
  end

  return ""
end

M.macro = function()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

M.record_typed_key = function()
  vim.on_key(function(key, typed)
    typed = typed or key
    if not typed or typed == "" then
      return
    end
    M.typed_key = vim.fn.keytrans(typed)
  end)
end

M.set_highlights = function()
  local groups = require("config.ui.statusline.highlights")

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M
