local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>rs", function()
  local refactoring = require("refactoring")
  local fzf_lua = require("fzf-lua")
  local results = refactoring.get_refactors()

  local opts = {
    fzf_opts = {},
    fzf_colors = true,
    actions = {
      ["default"] = function(selected)
        refactoring.refactor(selected[1])
      end,
    },
  }
  fzf_lua.fzf_exec(results, opts)
end, "Refactor")

set_keymap({ "n", "x" }, "<leader>re", function()
  return require("refactoring").refactor("Extract Function")
end, "Extract to function", { expr = true })

set_keymap({ "n", "x" }, "<leader>ri", function()
  return require("refactoring").refactor("Inline Variable")
end, "Inline Variable", { expr = true })

set_keymap({ "n", "x" }, "<leader>rb", function()
  return require("refactoring").refactor("Extract Block")
end, "Extract Block", { expr = true })

set_keymap({ "n", "x" }, "<leader>rf", function()
  return require("refactoring").refactor("Extract Block To File")
end, "Extract Block To File", { expr = true })

set_keymap("n", "<leader>rP", function()
  require("refactoring").debug.printf({ below = false })
end, "Debug Print")

set_keymap({ "n", "x" }, "<leader>rp", function()
  require("refactoring").debug.print_var({ normal = true })
end, "Debug Print Variable")

set_keymap("n", "<leader>rc", function()
  require("refactoring").debug.cleanup({})
end, "Debug Cleanup")

set_keymap({ "n", "x" }, "<leader>rf", function()
  return require("refactoring").refactor("Extract Function")
end, "Extract Function", { expr = true })

set_keymap({ "n", "x" }, "<leader>rF", function()
  return require("refactoring").refactor("Extract Function To File")
end, "Extract Function To File", { expr = true })

set_keymap({ "n", "x" }, "<leader>rx", function()
  return require("refactoring").refactor("Extract Variable")
end, "Extract Variable", { expr = true })

set_keymap({ "n", "x" }, "<leader>rp", function()
  require("refactoring").debug.print_var()
end, "Debug Print Variable")

return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
