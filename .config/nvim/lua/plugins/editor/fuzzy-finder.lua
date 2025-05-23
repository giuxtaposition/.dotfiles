return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local actions = require("fzf-lua.actions")
    return {
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
      fzf_opts = {
        ["--no-info"] = "",
        ["--info"] = "hidden",
        ["--layout"] = "reverse-list",
        ["--padding"] = "5%,5%,5%,5%",
      },
      files = {
        cwd_prompt = false,
      },
      grep = {
        rg_opts = "--hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
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
        code_actions = {
          prompt = " ",
          winopts = {
            width = 0.8,
            height = 0.7,
            preview = {
              layout = "horizontal",
              horizontal = "up:75%",
            },
          },
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
    }
  end,
  config = function(_, opts)
    require("fzf-lua").setup(opts)
  end,
  keys = {
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    {
      "<leader>fc",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "Find Config File",
    },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    {
      "<leader>ft",
      function()
        local file_name = vim.fn.expand("%:t:r")
        require("fzf-lua").files({ query = file_name })
      end,
      desc = "Find tests",
    },
    { "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Document diagnostics" },
    { "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
    { "<leader>fj", "<cmd>FzfLua changes<cr>", desc = "List Changes" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", desc = "Commits For Current Buffer" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>sf", "<cmd>FzfLua grep_cword<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "Find help tags" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>su", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "z=", "<Cmd>FzfLua spell_suggest<CR>", desc = "FzfLua: Find spell word suggestion" },
  },
}
