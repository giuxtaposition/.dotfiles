local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>ut", "<cmd>UndotreeToggle<cr>", "Toggle Undotree")

return {
  "mbbill/undotree",
  lazy = false,
  cmd = "UndotreeToggle",
  init = function()
    -- Settings
  end,
}
