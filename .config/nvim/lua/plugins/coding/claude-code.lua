vim.pack.add({
  { src = "https://github.com/coder/claudecode.nvim" },
})

require("claudecode").setup({
  auto_start = true,
  log_level = "warn",
  terminal = {
    split_side = "right",
    split_width_percentage = 0.35,
    provider = "native",
  },
  diff_opts = {
    open_in_new_tab = true,
    hide_terminal_in_new_tab = true,
  },
})

vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume session" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue session" })
vim.keymap.set({ "n", "v" }, "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
