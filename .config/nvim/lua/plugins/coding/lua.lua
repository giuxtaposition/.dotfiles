vim.pack.add({
  {
    src = "https://github.com/DrKJeff16/wezterm-types",
  },
  {
    src = "https://github.com/Bilal2453/luvit-meta",
  },
  {
    src = "https://github.com/LuaCATS/luassert",
    name = "luassert-types",
  },
  {
    src = "https://github.com/LuaCATS/busted",
    name = "busted-types",
  },
  {
    src = "https://github.com/folke/lazydev.nvim",
  },
})

local loaded = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    if loaded then
      return
    end
    require("lazydev").setup({
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { plugins = { "nvim-dap-ui" }, types = true },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      },
    })
    loaded = true
  end,
})
