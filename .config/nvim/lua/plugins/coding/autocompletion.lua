-- Native LSP autocompletion (nvim 0.12+).
-- Options set in config.options. This file wires per-buffer LSP completion,
-- snippet expansion via vim.snippet, signature help, and icons.

vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

local methods = vim.lsp.protocol.Methods
local kinds = vim.lsp.protocol.CompletionItemKind
local icons = require("config.ui.icons").kinds

-- Map LSP CompletionItemKind name → highlight group for colored icons.
local kind_hl = {
  Function = "Function",
  Method = "Function",
  Constructor = "Function",
  Macro = "Function",
  Class = "Type",
  Interface = "Type",
  Struct = "Type",
  TypeParameter = "Type",
  Enum = "Type",
  Array = "Type",
  Object = "Type",
  Variable = "Identifier",
  Field = "Identifier",
  Property = "Identifier",
  EnumMember = "Identifier",
  Key = "Identifier",
  Constant = "Constant",
  Number = "Number",
  Boolean = "Boolean",
  Null = "Constant",
  Event = "Constant",
  Unit = "Constant",
  Value = "Constant",
  String = "String",
  Text = "String",
  Keyword = "Keyword",
  Operator = "Operator",
  Reference = "Keyword",
  Snippet = "Special",
  Color = "Special",
  Copilot = "Special",
  File = "Directory",
  Folder = "Directory",
  Module = "Include",
  Package = "Include",
  Namespace = "Include",
}

-- Icon + short kind name in kind column (colored); plain label in abbr (readable).
local function convert(item)
  local kind_name = kinds[item.kind] or "Text"
  local icon = icons[kind_name] or " "
  local hl = kind_hl[kind_name] or "Normal"
  return {
    kind = icon .. " " .. kind_name,
    kind_hlgroup = hl,
    menu = item.detail or "",
  }
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local before = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(1, col)
  return col ~= 0 and before:match("%s$") == nil
end

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if vim.snippet.active({ direction = 1 }) then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  end
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  if has_words_before() then
    return "<C-x><C-o>"
  end
  return "<Tab>"
end, { expr = true, silent = true, desc = "Snippet jump / next completion / trigger LSP" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if vim.snippet.active({ direction = -1 }) then
    return "<Cmd>lua vim.snippet.jump(-1)<CR>"
  end
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  return "<S-Tab>"
end, { expr = true, silent = true, desc = "Snippet jump back / prev completion" })

vim.keymap.set("i", "<C-e>", "<C-e>", { silent = true, desc = "Hide completion" })

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true, silent = true, desc = "Accept selected completion" })

-- Cmdline auto-completion: fire wildmenu as user types in `:` cmdline.
vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("giuxtaposition-cmdline-auto", { clear = true }),
  pattern = ":",
  callback = function()
    if vim.fn.pumvisible() == 0 and vim.fn.wildmenumode() == 0 then
      pcall(vim.fn.wildtrigger)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("giuxtaposition-native-completion", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client:supports_method(methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
        convert = convert,
      })
    end

    if client:supports_method(methods.textDocument_signatureHelp) then
      local chars = (client.server_capabilities.signatureHelpProvider or {}).triggerCharacters or {}
      if #chars > 0 then
        vim.api.nvim_create_autocmd("TextChangedI", {
          buffer = ev.buf,
          callback = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line = vim.api.nvim_get_current_line()
            local ch = line:sub(cursor[2], cursor[2])
            for _, trigger in ipairs(chars) do
              if ch == trigger then
                vim.lsp.buf.signature_help()
                return
              end
            end
          end,
        })
      end
    end
  end,
})
