local M = {}

local KITTY_WINDOW = "nvim-test-runner"
local LOG_FILE = "/tmp/nvim-test-runner.log"
local last_cmd = nil

local function detect_runner()
  local pkg = vim.fn.getcwd() .. "/package.json"

  if vim.fn.filereadable(pkg) == 0 then
    return "unknown"
  end

  local content = table.concat(vim.fn.readfile(pkg), "\n")

  if content:match("vitest") then
    return "vitest"
  elseif content:match("jest") then
    return "jest"
  end

  return "unknown"
end

local function shell_escape(str)
  -- simple safe quoting
  return "'" .. str:gsub("'", "'\\''") .. "'"
end

local function escape_regex(str)
  return str:gsub("([%*%+%?%.%(%)%[%]%{%}%^%$%|%\\])", "\\%1")
end

local function get_node_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local parser = vim.treesitter.get_parser(0)
  local tree = parser:parse()[1]
  local root = tree:root()

  return root:named_descendant_for_range(row, col, row, col)
end

local function get_full_test_name()
  local node = get_node_at_cursor()
  local names = {}

  while node do
    if node:type() == "call_expression" then
      local fn = node:field("function")[1]

      if fn then
        local fn_name = vim.treesitter.get_node_text(fn, 0):gsub("%s+", "")

        if fn_name == "describe" or fn_name == "it" or fn_name == "test" then
          local args = node:field("arguments")[1]

          if args and args:named_child_count() > 0 then
            local first_arg = args:named_child(0)
            local text = vim.treesitter.get_node_text(first_arg, 0)

            text = text:gsub("^[\"'`]", ""):gsub("[\"'`]$", "")
            table.insert(names, 1, text)
          end
        end
      end
    end

    node = node:parent()
  end

  if #names > 0 then
    return table.concat(names, " ")
  end

  return nil
end

local function build_command(nearest)
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local runner = detect_runner()

  if runner == "vitest" then
    if nearest then
      local test_name = get_full_test_name()
      if test_name then
        return string.format("pnpm vitest run %s -t %s", file, shell_escape(escape_regex(test_name)))
      else
        return string.format("pnpm vitest run %s:%d", file, line)
      end
    end
    return string.format("pnpm vitest run %s", file)
  elseif runner == "jest" then
    if nearest then
      local test_name = get_full_test_name()
      if test_name then
        return string.format("pnpm jest --colors %s -t '%s'", file, escape_regex(test_name))
      end
    end
    return string.format("pnpm jest --colors %s", file)
  end

  return "pnpm test " .. file
end

local function send_command(cmd)
  last_cmd = cmd
  vim.fn.system({ "kitty", "@", "close-window", "--match", "title:" .. KITTY_WINDOW })

  local logged_cmd = cmd .. " 2>&1 | tee " .. LOG_FILE
  local init = "function fish_title; echo " .. KITTY_WINDOW .. "; end; " .. logged_cmd
  os.execute("kitty --title nvim-test-runner fish -C " .. shell_escape(init) .. " &")
end

local function build_path_command(path)
  local runner = detect_runner()
  if runner == "vitest" then
    return string.format("pnpm vitest run %s", shell_escape(path))
  elseif runner == "jest" then
    return string.format("pnpm jest --colors %s", shell_escape(path))
  end
  return "pnpm test " .. shell_escape(path)
end

local function strip_test_suffix(stem)
  return stem:gsub("%.spec$", ""):gsub("%.test$", ""):gsub("_spec$", ""):gsub("_test$", "")
end

M.detect_runner = detect_runner

function M.test_all()
  local runner = detect_runner()
  local cmd
  if runner == "vitest" then
    cmd = "pnpm vitest run"
  elseif runner == "jest" then
    cmd = "pnpm jest --colors"
  else
    cmd = "pnpm test"
  end
  send_command(cmd)
end

function M.test_file()
  local file_name = vim.fn.expand("%:t")
  local stem = file_name:match("^(.+)%.[^.]+$") or file_name
  local query = strip_test_suffix(stem)

  require("fzf-lua").fzf_exec("fd --type f --regex '[._](spec|test)\\.'", {
    prompt = " ",
    fzf_opts = { ["--query"] = query },
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          send_command(build_path_command(selected[1]))
        end
      end,
    },
  })
end

function M.test_nearest()
  send_command(build_command(true))
end

function M.test_last()
  if last_cmd then
    send_command(last_cmd)
  else
    vim.notify("No previous test to re-run", vim.log.levels.WARN)
  end
end

function M.test_folder()
  local cur_dir = vim.fn.expand("%:.:h")
  if cur_dir == "" then
    cur_dir = "."
  end
  local cmd = string.format(
    "{ echo %s; fd --type d --hidden --exclude .git --exclude node_modules; } | awk '!seen[$0]++'",
    shell_escape(cur_dir)
  )

  require("fzf-lua").fzf_exec(cmd, {
    prompt = " ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          send_command(build_path_command(selected[1]))
        end
      end,
    },
  })
end

return M
