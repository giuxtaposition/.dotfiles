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
    local bufnr = vim.api.nvim_get_current_buf()
    local active_clients = vim.lsp.get_clients({ bufnr })
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- prevent tsserver and volar competing
    -- if client.name == "volar" or require("lspconfig").util.root_pattern("nuxt.config.ts")(vim.fn.getcwd()) then
    -- OR
    if client.name == "volar" then
      for _, client_ in pairs(active_clients) do
        if client_.name == "typescript-tools" then
          client_.stop()
        end
      end
    elseif client.name == "typescript-tools" then
      for _, client_ in pairs(active_clients) do
        if client_.name == "volar" then
          client.stop()
        end
      end
    end
  end,
})
