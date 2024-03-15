return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false, auto_trigger = false },
      panel = { enabled = false },
      filetypes = {
        javascript = true, -- allow specific filetype
        typescript = true, -- allow specific filetype
        javascriptreact = true, -- allow specific filetype
        typescriptreact = true, -- allow specific filetype
        kotlin = true,
        ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
      copilot_node_command = "/home/giu/.asdf/installs/nodejs/21.5.0/bin/node",
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      require("giuxtaposition.config.util").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)
    end,
  },
}
