return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "giuxtaposition/neotest-jest",
      "marilari88/neotest-vitest",
      "weilbith/neotest-gradle",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
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
          require("neotest-gradle"),
          require("rustaceanvim.neotest"),
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
    },
  },
}
