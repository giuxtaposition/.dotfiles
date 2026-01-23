vim.pack.add({
  {
    src = "https://github.com/rachartier/tiny-code-action.nvim",
  },
})

require("tiny-code-action").setup({
  picker = {
    "buffer",
    opts = {
      hotkeys = true,
      -- Use numeric labels.
      hotkeys_mode = function(titles)
        return vim
          .iter(ipairs(titles))
          :map(function(i)
            return tostring(i)
          end)
          :totable()
      end,
    },
  },
})
