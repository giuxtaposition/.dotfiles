-- vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")

require("config")
require("plugins")

-- Enable experimental command-line features
require("vim._extui").enable({})
