---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true, -- Enable inlay hints globally
        paramName = "All", -- Parameter name hints: "All" | "Literal" | "Disable"
        paramType = true, -- Function parameter type hints
        setType = true, -- Assignment type hints
        arrayIndex = "Auto", -- Array index hints: "Enable" | "Auto" | "Disable"
        await = true, -- Await hints
        semicolon = "All", -- Semicolon hints: "All" | "SameLine" | "Disable"
      },
    },
  },
}
