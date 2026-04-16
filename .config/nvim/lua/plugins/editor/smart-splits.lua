local set_keymap = require("config.util.keys").set

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "smart-splits.nvim" and ev.data.kind == "install" then
      vim.defer_fn(function()
        vim.system({
          "bash",
          ev.data.path .. "/kitty/install-kittens.bash",
        }, { cwd = ev.data.path, text = true }, function(obj)
          print(obj.stdout)
          print(obj.stderr)
        end)
      end, 200)
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

require("smart-splits").setup()

-- Resize
set_keymap({ "n", "x" }, "<A-h>", require("smart-splits").resize_left, "Resize left")
set_keymap({ "n", "x" }, "<A-j>", require("smart-splits").resize_down, "Resize down")
set_keymap({ "n", "x" }, "<A-k>", require("smart-splits").resize_up, "Resize up")
set_keymap({ "n", "x" }, "<A-l>", require("smart-splits").resize_right, "Resize right")
set_keymap({ "n", "x" }, "<A-Left>", require("smart-splits").resize_left, "Resize left")
set_keymap({ "n", "x" }, "<A-Down>", require("smart-splits").resize_down, "Resize down")
set_keymap({ "n", "x" }, "<A-Up>", require("smart-splits").resize_up, "Resize up")
set_keymap({ "n", "x" }, "<A-Right>", require("smart-splits").resize_right, "Resize right")

-- Move
set_keymap({ "n", "x" }, "<C-h>", function()
  require("smart-splits").move_cursor_left()
end, "Focus left window")
set_keymap({ "n", "x" }, "<C-j>", require("smart-splits").move_cursor_down, "Focus bottom window")
set_keymap({ "n", "x" }, "<C-k>", require("smart-splits").move_cursor_up, "Focus top window")
set_keymap({ "n", "x" }, "<C-l>", require("smart-splits").move_cursor_right, "Focus right window")
set_keymap({ "n", "x" }, "<C-Left>", require("smart-splits").move_cursor_left, "Focus left window")
set_keymap({ "n", "x" }, "<C-Down>", require("smart-splits").move_cursor_down, "Focus bottom window")
set_keymap({ "n", "x" }, "<C-Up>", require("smart-splits").move_cursor_up, "Focus top window")
set_keymap({ "n", "x" }, "<C-Right>", require("smart-splits").move_cursor_right, "Focus right window")

-- Swap
set_keymap({ "n", "x" }, "<leader><leader>h", require("smart-splits").swap_buf_left, "Swap left buffer")
set_keymap({ "n", "x" }, "<leader><leader>j", require("smart-splits").swap_buf_down, "Swap bottom buffer")
set_keymap({ "n", "x" }, "<leader><leader>k", require("smart-splits").swap_buf_up, "Swap top buffer")
set_keymap({ "n", "x" }, "<leader><leader>l", require("smart-splits").swap_buf_right, "Swap right buffer")
set_keymap({ "n", "x" }, "<leader><leader>Left", require("smart-splits").swap_buf_left, "Swap left buffer")
set_keymap({ "n", "x" }, "<leader><leader>Down", require("smart-splits").swap_buf_down, "Swap bottom buffer")
set_keymap({ "n", "x" }, "<leader><leader>Up", require("smart-splits").swap_buf_up, "Swap top buffer")
set_keymap({ "n", "x" }, "<leader><leader>Right", require("smart-splits").swap_buf_right, "Swap right buffer")
