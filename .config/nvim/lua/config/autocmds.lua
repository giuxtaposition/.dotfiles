local function augroup(name)
  return vim.api.nvim_create_augroup("giuxtaposition_" .. name, { clear = true })
end

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  desc = "Go to the last location when opening a buffer",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  desc = "Auto-create missing dirs when saving a file",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight_on_yank"),
  callback = function()
    vim.hl.hl_op()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "lspinfo",
    "checkhealth",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Typescript: Change tab width according to prettierrc
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("change_tab_width_typescript"),
  desc = "Change tab width following prettier config",
  pattern = { "*.ts, *.tsx" },
  callback = function()
    local file_exists = vim.fn.filereadable(".prettierrc")

    if file_exists == 1 then
      local tabWidth = vim.fn.json_decode(vim.fn.readfile(".prettierrc"))["tabWidth"]
      vim.bo.shiftwidth = tabWidth
    end
  end,
})

-- Register a socket per working directory for lazygit integration
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("dir_socket"),
  desc = "Register a server socket based on the working directory",
  callback = function()
    local cwd = vim.fn.getcwd()
    local hash = vim.fn.sha256(cwd):sub(1, 8)
    local socket = "/tmp/nvim-" .. hash
    vim.fn.serverstart(socket)
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("keymap_filetype"),
  desc = "Set filetype to c for keymap files",
  pattern = "*.keymap",
  callback = function()
    vim.bo.filetype = "c"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("big_file"),
  desc = "Disable features in big files",
  pattern = "bigfile",
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or ""
    end)
  end,
})

-- Resize splits if the terminal window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  desc = "Resize splits when the terminal window is resized",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Enter insert mode when switching to a terminal buffer
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = augroup("terminal_insert"),
  desc = "Auto-enter insert mode in terminal buffers",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- No autocomment on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_autocomment"),
  desc = "Disable auto-commenting on new lines",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Show cursor line only in the active window
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = augroup("cursorline"),
  desc = "Show cursor line only in the active window",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = augroup("cursorline"),
  desc = "Disable cursor line in inactive windows",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Highlight the current word under the cursor using LSP reference highlight groups
vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup("highlight_word_under_cursor"),
  desc = "Highlight the current word under the cursor using LSP reference highlight groups",
  callback = function()
    if vim.fn.mode() ~= "i" then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local support_highlight = false
      for _, client in pairs(clients) do
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          support_highlight = true
          break
        end
      end
      if support_highlight then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end
  end,
})
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = augroup("highlight_word_under_cursor"),
  desc = "Clear LSP reference highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Markdown image preview (nvim 0.13+ native, kitty backend, PNG only)
if vim.ui and vim.ui.img then
  local state = { id = nil, file = nil, source = nil, png = nil, png_full = nil, is_png = false, fullscreen = false }

  local function parse_image(line)
    return line:match("!%[[^%]]*%]%(([^%)]+)%)")
  end

  local function is_web(file)
    return file:sub(1, 4) == "http"
  end

  local function clear()
    if state.id then
      pcall(vim.ui.img.del, state.id)
      state.id, state.file, state.source, state.png, state.png_full = nil, nil, nil, nil, nil
    end
    state.fullscreen = false
  end

  local function dims()
    local win_w = vim.api.nvim_win_get_width(0)
    if state.fullscreen then
      return { col = 3, row = 2, zindex = 100 }
    end
    local w = math.min(60, math.max(30, math.floor(win_w * 0.4)))
    local col = math.max(1, math.floor((win_w - w) / 2))
    return { col = col, row = 3, width = w }
  end

  local function place(png_bytes)
    vim.schedule(function()
      if state.id then
        pcall(vim.ui.img.del, state.id)
        state.id = nil
      end
      local ok, id = pcall(vim.ui.img.set, png_bytes, dims())
      if ok then
        state.id = id
      else
        vim.notify("img.set failed: " .. tostring(id), vim.log.levels.WARN)
      end
    end)
  end

  local function convert(args, source, cb)
    vim.system(args, { stdin = source }, function(res)
      if res.code == 0 and res.stdout and #res.stdout > 0 then
        cb(res.stdout)
      else
        vim.schedule(function()
          vim.notify("magick failed: " .. tostring(res.stderr), vim.log.levels.WARN)
        end)
      end
    end)
  end

  local function ensure_png(cb)
    if state.png then
      cb(state.png)
      return
    end
    if state.is_png then
      state.png = state.source
      cb(state.png)
    else
      convert({ "magick", "-", "png:-" }, state.source, function(png)
        state.png = png
        cb(png)
      end)
    end
  end

  local function render()
    if not state.source then
      return
    end
    ensure_png(place)
  end

  local function url_decode(s)
    return (s:gsub("%%(%x%x)", function(h)
      return string.char(tonumber(h, 16))
    end))
  end

  local function resolve(file)
    file = url_decode(file)
    if file:sub(1, 1) == "~" then
      return vim.fn.fnamemodify(file, ":p")
    end
    local rel = file:sub(1, 1) == "/" and file:sub(2) or file
    local buf = vim.api.nvim_buf_get_name(0)
    local candidates = { vim.fs.dirname(buf), vim.fn.getcwd() }
    for dir in vim.fs.parents(buf) do
      table.insert(candidates, dir)
    end
    for _, root in ipairs(candidates) do
      local p = vim.fs.normalize(vim.fs.joinpath(root, rel))
      if vim.fn.filereadable(p) == 1 then
        return p
      end
    end
    return file
  end

  local function get_blob(file, cb)
    if not is_web(file) then
      cb(vim.fn.readblob(resolve(file)))
      return
    end
    vim.net.request(file, {}, function(err, res)
      if err or not res then
        vim.schedule(function()
          vim.notify("image fetch failed: " .. tostring(err), vim.log.levels.WARN)
        end)
        return
      end
      cb(res.body)
    end)
  end

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorHold" }, {
    group = augroup("markdown_image_preview"),
    desc = "Preview markdown image under cursor",
    callback = function()
      if vim.bo.filetype ~= "markdown" or state.fullscreen then
        return
      end
      local file = parse_image(vim.api.nvim_get_current_line())
      if not file then
        clear()
        return
      end
      if file == state.file then
        return
      end
      if not is_web(file) then
        local resolved = resolve(file)
        if vim.fn.filereadable(resolved) ~= 1 then
          vim.notify("image not found: " .. file .. " (tried " .. resolved .. ")", vim.log.levels.WARN)
          return
        end
      end
      state.file = file
      state.is_png = file:lower():match("%.png$") ~= nil
      get_blob(file, function(bytes)
        state.source = bytes
        render()
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    group = augroup("markdown_image_preview_clear"),
    desc = "Clear markdown image preview on buffer leave",
    callback = clear,
  })

  vim.api.nvim_create_user_command("MdImgToggle", function()
    if not state.source then
      vim.notify("no image previewed", vim.log.levels.WARN)
      return
    end
    state.fullscreen = not state.fullscreen
    render()
    if state.fullscreen then
      vim.defer_fn(function()
        pcall(vim.fn.getcharstr)
        state.fullscreen = false
        render()
      end, 200)
    end
  end, {})

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_image_preview_keymap"),
    pattern = "markdown",
    callback = function(args)
      vim.keymap.set("n", "<leader>iv", "<cmd>MdImgToggle<cr>", { buffer = args.buf, desc = "Toggle image fullscreen" })
    end,
  })

  vim.api.nvim_create_user_command("MdImgDebug", function()
    local line = vim.api.nvim_get_current_line()
    local file = parse_image(line)
    vim.notify("line: " .. line, vim.log.levels.INFO)
    vim.notify("parsed: " .. tostring(file), vim.log.levels.INFO)
    if not file then
      return
    end
    if is_web(file) then
      vim.notify("web, skipping resolve", vim.log.levels.INFO)
      return
    end
    local resolved = resolve(file)
    vim.notify("resolved: " .. resolved, vim.log.levels.INFO)
    vim.notify("readable: " .. vim.fn.filereadable(resolved), vim.log.levels.INFO)
  end, {})
end
