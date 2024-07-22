return {
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
      { "<leader>cB", ":Refactor extract_block_to_file", desc = "Extract block to file" },
    },
  },
}
