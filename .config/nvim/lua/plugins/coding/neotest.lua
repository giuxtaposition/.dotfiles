local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>tt", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, "Run test file")
set_keymap("n", "<leader>tT", function()
  require("neotest").run.run(vim.uv.cwd())
end, "Run all test files")
set_keymap("n", "<leader>tr", function()
  require("neotest").run.run()
end, "Run nearest test")
set_keymap("n", "<leader>tl", function()
  require("neotest").run.run_last()
end, "Run last test")
set_keymap("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, "Toggle test summary")
set_keymap("n", "<leader>to", function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, "Show test output")
set_keymap("n", "<leader>tO", function()
  require("neotest").output_panel.toggle()
end, "Toggle test output panel")
set_keymap("n", "<leader>tS", function()
  require("neotest").run.stop()
end, "Stop test")
set_keymap("n", "<leader>tL", function()
  require("neotest").run.run_last({ strategy = "dap" })
end, "Debug last test")
set_keymap("n", "<leader>td", function()
  require("neotest").run.run({ strategy = "dap" })
end, "Debug Nearest")

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "weilbith/neotest-gradle",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-gradle"),
        },
      }
    end,
  },
}
