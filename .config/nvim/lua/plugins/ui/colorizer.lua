-- Lazy-loaded: colorizer deferred to first buffer read
vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/catgoose/nvim-colorizer.lua" } })

    require("colorizer").setup({
      filetypes = {
        "*",
        "!css",
        "!scss",
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = true,
        mode = "background",
      },
    })

    -- Trigger colorizer on the current buffer
    vim.cmd("ColorizerAttachToBuffer")
  end,
})
