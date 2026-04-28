-- Lazy-loaded: only needed for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/OXY2DEV/markview.nvim" },
      { src = "https://github.com/folke/snacks.nvim" },
    })

    local presets = require("markview.presets")
    require("markview").setup({
      markdown = {
        headings = vim.tbl_deep_extend("keep", {
          heading_1 = { sign = "" },
          heading_2 = { sign = "" },
          heading_3 = { sign = "" },
          heading_4 = { sign = "" },
          heading_5 = { sign = "" },
          heading_6 = { sign = "" },
        }, presets.headings.glow),
        horizontal_rules = presets.horizontal_rules.dotted,
      },
    })

    require("snacks").setup({
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = true,
        doc = {
          max_width = 45,
          max_height = 20,
        },
      },
    })
  end,
})
