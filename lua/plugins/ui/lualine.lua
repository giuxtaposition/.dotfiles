return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local icons = require("config.icons")
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "catppuccin",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard" } },
        section_separators = { left = "", right = "" },
        component_separators = "",
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          "branch",
        },
        lualine_c = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = "#c099ff" }
            end,
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = "#c099ff" }
            end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              local vtsls_client = "vtsls"
              if vim.lsp.get_clients({ name = vtsls_client })[1] then
                return " " .. vtsls_client
              end

              return " " .. vim.lsp.get_clients()[1].name
            end,
          },
        },
        lualine_y = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          "filename",
        },
        lualine_z = {
          function()
            return "󰉖 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
    return opts
  end,
}
