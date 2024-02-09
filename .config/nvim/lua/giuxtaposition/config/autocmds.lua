local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Jump to last edit position on opening file
autocmd("BufReadPost", {
  desc = "Open file at the last position it was edited earlier",
  group = augroup("last_position"),
  pattern = "*",
  command = 'silent! normal! g`"zv',
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Typescript: Remove unused imports on save
-- autocmd("BufWritePre", {
--   group = augroup("unused_imports_on_save_typescript"),
--   desc = "remove unused imports on save for typescript files",
--   callback = function()
--     local filetype = vim.bo.filetype
--     if filetype == "typescript" or filetype == "typescriptreact" then
--       vim.cmd("TSToolsRemoveUnusedImports")
--     end
--   end,
-- })

-- Typescript: Change tab width according to prettierrc
autocmd("BufEnter", {
  group = augroup("change_tab_width_typescript"),
  desc = "Change tab width following prettier config",
  pattern = { "*.ts, *.tsx" },
  callback = function()
    local file_exists = vim.fn.filereadable(".prettierrc")

    if file_exists == 1 then
      local tabWidth = vim.fn.json_decode(vim.fn.readfile(".prettierrc"))["tabWidth"]
      vim.bo.shiftwidth = tabWidth
    end
  end,
})

local lsp_conficts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
if not lsp_conficts then
  vim.api.nvim_create_augroup("LspAttach_conflicts", {})
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_conflicts",
  desc = "prevent tsserver and volar competing",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local active_clients = vim.lsp.get_active_clients()
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- prevent tsserver and volar competing
    -- if client.name == "volar" or require("lspconfig").util.root_pattern("nuxt.config.ts")(vim.fn.getcwd()) then
    -- OR
    if client.name == "volar" then
      for _, client_ in pairs(active_clients) do
        -- stop tsserver if volar is already active
        if client_.name == "typescript-tools" then
          client_.stop()
        end
      end
    elseif client.name == "typescript-tools" then
      for _, client_ in pairs(active_clients) do
        -- prevent tsserver from starting if volar is already active
        if client_.name == "volar" then
          client.stop()
        end
      end
    end
  end,
})
