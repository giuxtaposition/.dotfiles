vim.pack.add({
  { src = "https://github.com/OXY2DEV/markview.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/zk-org/zk-nvim" },
  { src = "https://github.com/HakonHarnes/img-clip.nvim" },
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
      inline = false,
      max_width = 45,
      max_height = 20,
    },
    wo = {
      winhighlight = "FloatBorder:WhichKeyBorder",
    },
  },
})

vim.env.ZK_NOTEBOOK_DIR = vim.fn.expand("~/notes")

require("zk").setup({
  picker = "fzf_lua",
  lsp = {
    auto_attach = { enabled = false },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    if require("zk.util").notebook_root(vim.fn.expand("%:p")) then
      require("zk.lsp").buf_add(ev.buf)
    end
  end,
})

require("img-clip").setup({
  default = {
    dir_path = vim.fn.expand("~/notes/assets"),
    use_absolute_path = false,
    relative_to_current_file = false,
    url_encode_path = true,
    template = "![]($FILE_PATH)",
    prompt_for_file_name = false,
  },
})

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>pi", "<cmd>PasteImage<cr>", "Paste image")
set_keymap("n", "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", "New note")
set_keymap("n", "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", "Open notes")
set_keymap("n", "<leader>zt", "<cmd>ZkTags<cr>", "Browse tags")
set_keymap("n", "<leader>zf", function()
  require("zk.api").list(
    vim.env.ZK_NOTEBOOK_DIR,
    { sort = { "modified" }, select = { "title", "absPath", "tags", "filenameStem" } },
    function(err, notes)
      if err then
        vim.notify("zk: " .. vim.inspect(err), vim.log.levels.ERROR)
        return
      end
      local items = vim.tbl_map(function(note)
        local tags = note.tags and #note.tags > 0 and " [" .. table.concat(note.tags, ", ") .. "]" or ""
        local label = (note.title or note.filenameStem) .. tags
        return label .. "\t" .. note.absPath
      end, notes)
      require("fzf-lua").fzf_exec(items, {
        prompt = "Notes> ",
        fzf_opts = {
          ["--delimiter"] = "\t",
          ["--with-nth"] = "1",
          ["--preview"] = "bat --style=plain --color=always {2}",
        },
        actions = {
          ["default"] = function(selected)
            if not selected or not selected[1] then
              return
            end
            local path = selected[1]:match("\t(.+)$")
            if path then
              vim.cmd("edit " .. vim.fn.fnameescape(path))
            end
          end,
        },
      })
    end
  )
end, "Search notes (title + tags)")
set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<cr>", "Search selection")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= "zk" then
      return
    end
    local buf = ev.buf
    set_keymap("n", "<CR>", "<cmd>lua vim.lsp.buf.definition()<cr>", "Follow link", { buffer = buf })
    set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Preview note", { buffer = buf })
    set_keymap(
      "n",
      "<leader>zn",
      "<cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<cr>",
      "New note (here)",
      { buffer = buf }
    )
    set_keymap("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", "Backlinks", { buffer = buf })
    set_keymap("n", "<leader>zl", "<cmd>ZkLinks<cr>", "Links", { buffer = buf })
    set_keymap(
      "v",
      "<leader>znt",
      ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>",
      "New note from title",
      { buffer = buf }
    )
    set_keymap(
      "v",
      "<leader>znc",
      ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<cr>",
      "New note from content",
      { buffer = buf }
    )
  end,
})
