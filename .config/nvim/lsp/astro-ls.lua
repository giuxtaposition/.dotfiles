---@type vim.lsp.Config
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  init_options = {
    typescript = {
      tsdk = "",
    },
  },
  before_init = function(_, config)
    local function is_ts_lib(dir)
      return vim.uv.fs_stat(dir .. "/typescript.js") ~= nil and vim.uv.fs_stat(dir .. "/tsserverlibrary.js") ~= nil
    end

    -- Prefer workspace typescript
    local root = config.root_dir
    if root then
      local ws = root .. "/node_modules/typescript/lib"
      if is_ts_lib(ws) then
        config.init_options.typescript.tsdk = ws
        return
      end
    end

    -- Fall back to typescript bundled with astro-language-server
    local astro_bin = vim.fn.exepath("astro-ls")
    if astro_bin == "" then
      return
    end
    local real = vim.uv.fs_realpath(astro_bin)
    if not real then
      return
    end
    for dir in vim.fs.parents(real) do
      local candidate = dir .. "/node_modules/typescript/lib"
      if is_ts_lib(candidate) then
        config.init_options.typescript.tsdk = candidate
        return
      end
    end
  end,
}
