return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      vim.list_extend(opts.filetypes, {
        javascript = true,
        typescript = true,
      })
    end,
  },
}
