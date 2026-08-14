vim.pack.add({
  { src = "file:///" .. "home/giu/Programming/claudecode.nvim" },
  -- { src = "https://github.com/coder/claudecode.nvim" },
})

local claudecode = require("claudecode")

claudecode.setup({
  auto_start = false,
  log_level = "debug",
  terminal = {
    split_side = "bottom",
    split_width_percentage = 0.25,
    provider = "native",
  },
  diff_opts = {
    open_in_new_tab = true,
  },
})

local function ensure_started()
  if not claudecode.state or not claudecode.state.server then
    claudecode.start(false)
  end
end

local function toggle_claude()
  ensure_started()
  vim.cmd("ClaudeCode")
end

local function send_paths(selected, opts)
  ensure_started()
  for _, entry in ipairs(selected) do
    local parsed = require("fzf-lua.path").entry_to_file(entry, opts)
    if parsed.path and parsed.path ~= "" then
      claudecode.send_at_mention(parsed.path, nil, nil, "fzf-lua")
    end
  end
end

local function send_grep(selected, opts)
  ensure_started()
  for _, entry in ipairs(selected) do
    local parsed = require("fzf-lua.path").entry_to_file(entry, opts)
    if parsed.path and parsed.path ~= "" then
      local line = tonumber(parsed.line)
      claudecode.send_at_mention(parsed.path, line, line, "fzf-lua-grep")
    end
  end
end

local function fzf_files_to_claude()
  require("fzf-lua").files({
    prompt = "Send to Claude ",
    actions = { ["default"] = send_paths },
  })
end

local function fzf_grep_to_claude()
  require("fzf-lua").live_grep({
    prompt = "Grep to Claude ",
    actions = { ["default"] = send_grep },
  })
end

local function fzf_buffers_to_claude()
  require("fzf-lua").buffers({
    prompt = "Send buffer to Claude ",
    actions = { ["default"] = send_paths },
  })
end

vim.keymap.set("n", "<leader>aa", toggle_claude, { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume session" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue session" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
vim.keymap.set("n", "<leader>aF", fzf_files_to_claude, { desc = "Fzf files to Claude" })
vim.keymap.set("n", "<leader>ag", fzf_grep_to_claude, { desc = "Fzf grep to Claude" })
vim.keymap.set("n", "<leader>aB", fzf_buffers_to_claude, { desc = "Fzf buffers to Claude" })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if not name:match("claude") then
      return
    end
    -- vim.bo[args.buf].buflisted = false
    vim.wo.foldcolumn = "0" -- left pad
    vim.wo.signcolumn = "no"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.winbar = " " -- top pad
    vim.wo.winhighlight = "FoldColumn:Normal,WinBar:Normal,WinBarNC:Normal"
  end,
})
