vim.lsp.enable({
  "vtsls",
  "eslint",
  "cssls",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "svelte",
        "vue",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettierd" },
        ["javascriptreact"] = { "prettierd" },
        ["typescript"] = { "prettierd" },
        ["typescriptreact"] = { "prettierd" },
        ["vue"] = { "prettierd" },
        ["css"] = { "prettierd" },
        ["scss"] = { "prettierd" },
        ["less"] = { "prettierd" },
        ["html"] = { "prettierd" },
        ["svelte"] = { "prettier" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- Setup adapters
      dap.adapters = {
        ["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = "js-debug", args = { "${port}" } },
        },
      }

      -- Setup configurations
      local js_based_languages = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
      }

      for _, ext in ipairs(js_based_languages) do
        dap.configurations[ext] = {
          -- Debug single file
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          -- Attach to process
          -- NOTE: must start node process with --inspect or equivalent
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "giuxtaposition/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-jest")({
            jestCommand = function(path)
              if string.match(path, "%." .. "integration%-spec") then
                return "npm run test:integration --"
              end

              if string.match(path, "%." .. "api%-spec") then
                return "npm run test:api --"
              end

              if string.match(path, "%" .. "/src/pages/") then
                return "npm run test:component --"
              end

              return "npm run test --"
            end,
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
            testFileNames = { "api%-spec", "component%-spec", "integration%-spec", "test", "spec" },
          }),
          require("neotest-vitest"),
        },
      }
    end,
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "dmmulroy/tsc.nvim",
    opts = {
      use_trouble_qflist = true,
      auto_close_qflist = true,
    },
    config = function(_, opts)
      require("tsc").setup(opts)
    end,
  },
}
