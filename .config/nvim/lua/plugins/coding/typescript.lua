-- Lazy-loaded: TypeScript tooling deferred to relevant filetypes/commands

local ts_fts = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "html" }

-- nvim-ts-autotag: defer to first relevant filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_fts,
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/windwp/nvim-ts-autotag" } })
    require("nvim-ts-autotag").setup()
  end,
})

-- tsc.nvim: defer to :TSC command
vim.api.nvim_create_user_command("TSC", function(opts)
  vim.api.nvim_del_user_command("TSC")
  vim.pack.add({ { src = "https://github.com/dmmulroy/tsc.nvim" } })
  require("tsc").setup({
    use_trouble_qflist = true,
    auto_close_qflist = true,
    flags = "-b",
  })
  vim.cmd("TSC " .. (opts.args or ""))
end, { nargs = "*" })

-- ts-error-translator: defer to TS/JS filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/dmmulroy/ts-error-translator.nvim" } })
    require("ts-error-translator").setup({ auto_attach = true, servers = { "vtsls" } })
  end,
})
