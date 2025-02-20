return {
  -- Add/delete/change surrounding pairs
  {
    "kylechui/nvim-surround",
    version = "*",
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
