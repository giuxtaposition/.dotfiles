vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
  },
  {
    src = "https://github.com/ibhagwan/fzf-lua",
  },
})

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
  fzf_bin = "sk",
  fzf_opts = {
    ["--algo"] = "frizbee",
    ["--no-info"] = "",
    ["--info"] = "hidden",
    ["--layout"] = "reverse-list",
    ["--extended"] = "",
  },
  defaults = {
    prompt = " ",
    header = false,
    formatter = "path.filename_first",
  },
  winopts = {
    height = 0.8,
    width = 0.9,
    border = "none",
    preview = {
      scrollbar = false,
      horizontal = "right:50%",
    },
    on_create = function()
      vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
      vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
    end,
  },
  files = {
    cwd_prompt = false,
  },
  grep = {
    rg_opts = "--hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    rg_glob = true,
    rg_glob_fn = function(query, opts)
      local regex, flags = query:match("^(.-)%s%-%-(.*)$")

      local function rebuild_regex(str)
        local result = str:gsub("%s+", function(r)
          if #r == 1 then
            return ".*"
          else
            return r:match("%s(.*)")
          end
        end)
        return result
      end

      if not regex then
        return rebuild_regex(query), ""
      end

      return rebuild_regex(regex), flags
    end,
    glob_separator = "",
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  actions = {
    files = {
      ["enter"] = actions.file_edit_or_qf,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["alt-q"] = actions.file_sel_to_qf,
    },
  },
  helptags = {
    prompt = " ",
    actions = {
      -- Open help pages in a vertical split.
      ["enter"] = actions.help_vert,
    },
  },
  lsp = {
    symbols = {
      symbol_icons = require("config.ui.icons").kinds,
    },
  },
  oldfiles = {
    include_current_session = true,
  },
  buffers = {},
  previewers = {
    builtin = {
      extensions = {
        ["jpg"] = { "ueberzug" },
        ["png"] = { "ueberzug" },
        ["svg"] = { "ueberzug" },
      },
      -- if using `ueberzug` in the above extensions map
      -- set the default image scaler, possible scalers:
      --   false (none), "crop", "distort", "fit_contain",
      --   "contain", "forced_cover", "cover"
      -- https://github.com/seebye/ueberzug
      ueberzug_scaler = "cover",
      syntax_limit_b = 1024 * 100, -- 100KB
    },
  },
})

vim.ui.select = function(items, opts, on_choice)
  local ui_select = require("fzf-lua.providers.ui_select")

  -- Register the fzf-lua picker the first time we call select.
  if not ui_select.is_registered() then
    ui_select.register(function(ui_opts)
      ui_opts.winopts = { height = 0.5, width = 0.4 }

      -- Use the kind (if available) to set the previewer's title.
      if ui_opts.kind then
        ui_opts.winopts.title = string.format(" %s ", ui_opts.kind)
      end

      return ui_opts
    end)
  end

  -- Don't show the picker if there's nothing to pick.
  if #items > 0 then
    return vim.ui.select(items, opts, on_choice)
  end
end

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>e", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ":p")
  local current_buffer_dir = vim.fn.fnamemodify(bufname, ":p:h")

  if path and vim.uv.fs_stat(path) then
    require("mini.files").open(bufname, false)
  else
    require("mini.files").open(current_buffer_dir, false)
  end
end, "File explorer")

set_keymap("n", "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", "Buffers")
set_keymap("n", "<leader>fc", function()
  require("fzf-lua").files({
    cwd = vim.fn.stdpath("config"),
  })
end, "Find Config File")
set_keymap("n", "<leader>ff", "<cmd>FzfLua files<cr>", "Find Files")
set_keymap("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", "Recent")
set_keymap("n", "<leader>ft", function()
  -- Get current filename (no path)
  local file_name = vim.fn.expand("%:t")
  -- Part before the first dot
  local base = file_name:match("^[^.]+")
  -- Build a query: base + (spec OR test)
  local query = string.format("%s spec | test", base)

  require("fzf-lua").files({
    query = query,
  })
end, "Find tests")
set_keymap("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", "Document diagnostics")
set_keymap("n", "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "Workspace diagnostics")
set_keymap("n", "<leader>fj", "<cmd>FzfLua changes<cr>", "List Changes")
-- git
set_keymap("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", "Commits")
set_keymap("n", "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", "Commits For Current Buffer")
set_keymap("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", "Status")
-- search
set_keymap("n", '<leader>s"', "<cmd>FzfLua registers<cr>", "Registers")
set_keymap("n", "<leader>sC", "<cmd>FzfLua commands<cr>", "Commands")
set_keymap("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>", "Find string in cwd")
set_keymap("n", "<leader>sf", "<cmd>FzfLua grep_cword<cr>", "Find string under cursor in cwd")
set_keymap("n", "<leader>sh", "<cmd>FzfLua helptags<cr>", "Find help tags")
set_keymap("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", "Key Maps")
set_keymap("n", "<leader>su", "<cmd>FzfLua highlights<cr>", "Highlights")
set_keymap("n", "<leader>sR", "<cmd>FzfLua resume<cr>", "Resume")
set_keymap("n", "<leader>gS", function()
  require("fzf-lua").live_grep({
    search_paths = vim.fn.systemlist("git status --porcelain | cut -c4-"),
  })
end, "Find string in git status files")
set_keymap("n", "z=", "<cmd>FzfLua spell_suggest<cr>", "Find spell word suggestion")
set_keymap("n", "<leader>ut", "<cmd>FzfLua undotree<cr>", "Undotree")
