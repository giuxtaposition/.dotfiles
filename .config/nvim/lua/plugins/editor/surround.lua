return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        normal = "gsa",
        normal_cur = "gss",
        normal_line = "gsS",
        visual = "gsa",
        delete = "gsd",
        change = "gsr",
      },
    },
  },
}
