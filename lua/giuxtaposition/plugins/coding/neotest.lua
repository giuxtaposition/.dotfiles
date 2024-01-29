return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "giuxtaposition/neotest-jest",
      "marilari88/neotest-vitest",
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
          require("neotest").run.run(vim.loop.cwd())
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
            jestCommand = "npm test --",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
            testFileNames = { "spec", "component%-spec", "test" },
          }),
          require("neotest-vitest"),
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
