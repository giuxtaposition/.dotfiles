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

-- Parsers are installed on demand instead of from a hardcoded list: the first
-- time a filetype is opened its parser is fetched, then highlighting and
-- treesitter indentation start.

--- @type string[]?
local available

--- @param buf integer
--- @param lang string
--- @return boolean started whether a parser was loaded for `lang`
local function start_treesitter(buf, lang)
  if not vim.treesitter.language.add(lang) then
    return false
  end
  vim.treesitter.start(buf, lang)
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  return true
end

--- @param lang string
--- @return boolean
local function is_installable(lang)
  available = available or ts.get_available()
  return vim.list_contains(available, lang)
end

local installing = {}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  desc = "Start treesitter, installing the parser on first use",
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match)
    if not lang or start_treesitter(event.buf, lang) then
      return
    end

    -- Only try to fetch a parser once per session, so a language without a
    -- grammar (or a failing build) doesn't retry on every buffer.
    if installing[lang] or not is_installable(lang) then
      return
    end
    installing[lang] = true

    ts.install(lang):await(function(err)
      if err then
        return
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(event.buf) then
          start_treesitter(event.buf, lang)
        end
      end)
    end)
  end,
})

require("treesitter-context").setup({
  max_lines = 5,
})

set_keymap("n", "[C", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, "Jump to context")
