local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Breakpoint Condition")

set_keymap("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, "Toggle Breakpoint")

set_keymap("n", "<leader>dc", function()
  require("dap").continue()
end, "Continue")

set_keymap("n", "<leader>dC", function()
  require("dap").run_to_cursor()
end, "Run to Cursor")

set_keymap("n", "<leader>dg", function()
  require("dap").goto_()
end, "Go to Line (No Execute)")

set_keymap("n", "<leader>di", function()
  require("dap").step_into()
end, "Step Into")

set_keymap("n", "<leader>dj", function()
  require("dap").down()
end, "Down")

set_keymap("n", "<leader>dk", function()
  require("dap").up()
end, "Up")

set_keymap("n", "<leader>dl", function()
  require("dap").run_last()
end, "Run Last")

set_keymap("n", "<leader>do", function()
  require("dap").step_out()
end, "Step Out")

set_keymap("n", "<leader>dO", function()
  require("dap").step_over()
end, "Step Over")

set_keymap("n", "<leader>dp", function()
  require("dap").pause()
end, "Pause")

set_keymap("n", "<leader>dr", function()
  require("dap").repl.toggle()
end, "Toggle REPL")

set_keymap("n", "<leader>ds", function()
  require("dap").session()
end, "Session")

set_keymap("n", "<leader>dt", function()
  require("dap").terminate()
end, "Terminate")

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {
          winbar = {
            sections = { "scopes", "breakpoints", "threads", "exceptions", "repl", "console" },
            default_section = "scopes",
          },
          windows = { height = 18 },
        },
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      local dap, dv = require("dap"), require("dap-view")

      require("dap").set_log_level("TRACE")

      -- UI
      local icons = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
      }
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Automatically open the UI when a new debug session is created.
      dap.listeners.before.attach["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.launch["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.event_terminated["dap-view-config"] = function()
        dv.close()
      end
      dap.listeners.before.event_exited["dap-view-config"] = function()
        dv.close()
      end
    end,
  },
}
