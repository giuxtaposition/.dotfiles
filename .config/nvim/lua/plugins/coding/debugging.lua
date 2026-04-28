-- Lazy-loaded: DAP is only loaded on first <leader>d keymap press
local dap_loaded = false

local function ensure_dap()
  if dap_loaded then
    return
  end
  dap_loaded = true

  vim.pack.add({
    { src = "https://github.com/igorlfs/nvim-dap-view" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
  })

  require("nvim-dap-virtual-text").setup()

  local dap, dv = require("dap"), require("dap-view")

  dv.setup({
    winbar = {
      sections = { "scopes", "breakpoints", "threads", "exceptions", "repl", "console" },
      default_section = "scopes",
    },
  })

  -- UI
  local icons = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
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

  -- Automatically open/close the UI
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
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
  end
end

-- Register keymaps that trigger lazy load
local function dap_cmd(fn_name, ...)
  local args = { ... }
  return function()
    ensure_dap()
    local dap = require("dap")
    local fn = dap
    for part in fn_name:gmatch("[^.]+") do
      fn = fn[part]
    end
    fn(unpack(args))
  end
end

local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { desc = desc, silent = true })
end

map("<leader>dB", function()
  ensure_dap()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Breakpoint Condition")
map("<leader>db", dap_cmd("toggle_breakpoint"), "Toggle Breakpoint")
map("<leader>dc", dap_cmd("continue"), "Continue")
map("<leader>dC", dap_cmd("run_to_cursor"), "Run to Cursor")
map("<leader>dg", dap_cmd("goto_"), "Go to Line (No Execute)")
map("<leader>di", dap_cmd("step_into"), "Step Into")
map("<leader>dj", dap_cmd("down"), "Down")
map("<leader>dk", dap_cmd("up"), "Up")
map("<leader>dl", dap_cmd("run_last"), "Run Last")
map("<leader>do", dap_cmd("step_out"), "Step Out")
map("<leader>dO", dap_cmd("step_over"), "Step Over")
map("<leader>dp", dap_cmd("pause"), "Pause")
map("<leader>dr", dap_cmd("repl.toggle"), "Toggle REPL")
map("<leader>ds", dap_cmd("session"), "Session")
map("<leader>dt", dap_cmd("terminate"), "Terminate")
