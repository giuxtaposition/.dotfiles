return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "nix",
        "svelte",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        init = function()
          require("lazyvim.util.lsp").on_attach(function(_, buffer)
            vim.keymap.set(
              "n",
              "<leader>co",
              "<cmd>TSToolsOrganizeImports<cr>",
              { buffer = buffer, desc = "Organize Imports" }
            )
            vim.keymap.set("n", "<leader>cR", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename File", buffer = buffer })
            vim.keymap.set(
              "n",
              "<leader>cc",
              "<cmd>TSToolsRemoveUnused<cr>",
              { desc = "Remove Unused", buffer = buffer }
            )
            vim.keymap.set("n", "<leader>cC", "<cmd>TSC<cr>", { desc = "Check Compile Errors", buffer = buffer })
            vim.keymap.set(
              "n",
              "<leader>cA",
              "<cmd>TSToolsAddMissingImports<cr>",
              { desc = "Add Missing Imports", buffer = buffer }
            )
          end)
        end,
      },
      {
        "nvimdev/lspsaga.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
        config = function()
          require("lspsaga").setup({ -- keybinds for navigation in lspsaga window
            scroll_preview = { scroll_down = "<C-j>", scroll_up = "<C-k>" },
            -- use enter to open file with definition preview
            definition = {
              keys = {
                edit = "<CR>",
                vsplit = "v",
                split = "h",
              },
            },
            finder = {
              keys = {
                edit = "<CR>",
                toggle_or_open = "<TAB>",
                vsplit = "v",
                split = "h",
              },
            },
            rename = {
              keys = {
                quit = "<C-q>",
              },
              in_select = false,
            },
            ui = {
              kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
              devicon = true,
              expand = "󰁌",
              collapse = "󰡍",
            },
          })
        end,
      },
    },
    init = function()
      local lspsaga_diagnostic = require("lspsaga.diagnostic")
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "gf", "<cmd>Lspsaga finder<CR>", {
        desc = "References",
      } }
      keys[#keys + 1] = { "gd", "<cmd>Lspsaga peek_definition<CR>", {
        desc = "Goto Definition",
      } }
      keys[#keys + 1] = { "<leader>ca", "<cmd>Lspsaga code_action<CR>", {
        desc = "Code Action",
      } }
      keys[#keys + 1] = { "<leader>cr", "<cmd>Lspsaga rename<CR>", {
        desc = "Rename",
      } }
      keys[#keys + 1] = {
        "<leader>cD",
        "<cmd>Lspsaga show_line_diagnostics<CR>",
        {
          desc = "Line Diagnostics",
        },
      }
      keys[#keys + 1] = {
        "<leader>cd",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        {
          desc = "Cursor Diagnostics",
        },
      }
      keys[#keys + 1] = {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        {
          desc = "Hover Documentation",
        },
      }
      keys[#keys + 1] = {
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<cr>",
        {
          desc = "Prev Diagnostic",
        },
      }
      keys[#keys + 1] = {
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<cr>",
        {
          desc = "Next Diagnostic",
        },
      }
      keys[#keys + 1] = {
        "[e",
        function()
          lspsaga_diagnostic:goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        {
          desc = "Prev Error",
        },
      }
      keys[#keys + 1] = {
        "]e",
        function()
          lspsaga_diagnostic:goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        {
          desc = "Next Error",
        },
      }
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      inlay_hints = { enabled = true },
      servers = {
        tsserver = {
          settings = {
            separate_diagnostic_server = true,
            composite_mode = "separate_diagnostic",
            expose_as_code_action = {},
            complete_function_calls = true,
            tsserver_file_preferences = {
              includeCompletionsForModuleExports = true,
              quotePreference = "auto",
              importModuleSpecifierPreference = "relative",

              -- inlay hints
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        bashls = {},
        svelte = {},
        cssls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript-tools").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    keys = {
      { "<leader>ce", ":Refactor extract ", mode = "x", desc = "Extract to function" },
      { "<leader>cf", ":Refactor extract_to_file ", mode = "x", desc = "Extract to file" },
      { "<leader>cv", ":Refactor extract_var ", mode = "x", desc = "Extract to variable" },
      { "<leader>ci", ":Refactor inline_var", mode = { "n", "x" }, desc = "Inline variable" },
      { "<leader>cb", ":Refactor extract_block", desc = "Extract block to function" },
      { "<leader>cbf", ":Refactor extract_block_to_file", desc = "Extract block to file" },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      vim.list_extend(opts.filetypes, {
        javascript = true,
        typescript = true,
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
      {
        "<leader>tL",
        function()
          require("neotest").run.run_last({ strategy = "dap" })
        end,
        desc = "Debug Last Test",
      },
      {
        "<leader>tw",
        "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
        desc = "Run Watch",
      },
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(opts.adapters, require("neotest-vitest"))
    end,
  },
}
