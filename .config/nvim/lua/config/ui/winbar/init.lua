--- Winbar setup: highlights, autocmds, and winbar option.
--- Usage: require("config.ui.winbar").setup()
--- Or use the render function directly: require("config.ui.winbar").render()

local symbols = require("config.ui.winbar.symbols")
local render = require("config.ui.winbar.render")
local colors = require("config.ui.colors")

local M = {}

local function set_highlights()
  local kind_colors = {
    File = colors.mauve,
    Module = colors.mauve,
    Namespace = colors.mauve,
    Package = colors.mauve,
    Class = colors.yellow,
    Method = colors.lavender,
    Property = colors.sky,
    Field = colors.sky,
    Constructor = colors.yellow,
    Enum = colors.yellow,
    Interface = colors.yellow,
    Function = colors.lavender,
    Variable = colors.pink,
    Constant = colors.peach,
    String = colors.green,
    Number = colors.peach,
    Boolean = colors.peach,
    Array = colors.mauve,
    Object = colors.yellow,
    Key = colors.sky,
    Null = colors.red,
    EnumMember = colors.sky,
    Struct = colors.yellow,
    Event = colors.peach,
    Operator = colors.pink,
    TypeParameter = colors.yellow,
  }

  vim.api.nvim_set_hl(0, "WinBar", { fg = colors.subtext1, bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.surface2, bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBar_Separator", { fg = colors.surface2, bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBar_Modified", { fg = colors.green, bg = "NONE" })

  for kind_name, color in pairs(kind_colors) do
    vim.api.nvim_set_hl(0, "WinBar_Kind" .. kind_name, { fg = color, bg = "NONE" })
  end
end

--- @type number[]
local excluded_buftypes = { "nofile", "terminal", "prompt", "help", "quickfix" }

local function should_attach(bufnr)
  local bt = vim.bo[bufnr].buftype
  for _, excluded in ipairs(excluded_buftypes) do
    if bt == excluded then
      return false
    end
  end
  return vim.api.nvim_buf_get_name(bufnr) ~= ""
end

function M.render()
  return render.render()
end

function M.setup()
  set_highlights()

  vim.o.winbar = "%{%v:lua.require'config.ui.winbar'.render()%}"

  local group = vim.api.nvim_create_augroup("my_winbar", { clear = true })

  -- Fetch symbols on buffer/LSP events (cache refresh)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    callback = function(args)
      if should_attach(args.buf) then
        symbols.invalidate(args.buf)
        symbols.fetch(args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      if should_attach(args.buf) then
        -- Small delay to let the LSP initialize
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            symbols.invalidate(args.buf)
            symbols.fetch(args.buf)
          end
        end, 500)
      end
    end,
  })

  -- Redraw winbar on cursor movement (uses cached symbols, no LSP call)
  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
    group = group,
    callback = function(args)
      if should_attach(args.buf) then
        vim.wo.winbar = vim.o.winbar
      end
    end,
  })

  -- Clean up on buffer delete
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      symbols.on_buf_delete(args.buf)
    end,
  })

  -- Re-apply highlights on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = set_highlights,
  })
end

return M
