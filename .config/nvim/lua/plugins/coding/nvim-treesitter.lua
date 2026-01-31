vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  },
})
local ts = require("nvim-treesitter")
local set_keymap = require("config.util.keys").set

ts.install({
  "bash",
  "c",
  "comment",
  "diff",
  "dockerfile",
  "fish",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "ini",
  "jsdoc",
  "json",
  "json5",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "nix",
  "php",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "svelte",
  "vue",
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" then
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local filetype = vim.bo.filetype
    if filetype and filetype ~= "" then
      local success = pcall(function()
        vim.treesitter.start()
      end)
      if not success then
        return
      end
    end
  end,
})

set_keymap("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, "Jump to context")
