local M = {}

local KITTY_WINDOW = "nvim-test-runner"
local LOG_FILE = "/tmp/nvim-test-runner.log"

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
        return string.format("pnpm vitest run %s -t %s", file, shell_escape(test_name))
      else
        return string.format("pnpm vitest run %s:%d", file, line)
      end
    end
    return string.format("pnpm vitest run %s", file)
  elseif runner == "jest" then
    if nearest then
      local test_name = get_full_test_name()
      if test_name then
        return string.format("pnpm jest %s -t '%s'", file, test_name)
      end
    end
    return string.format("pnpm jest %s", file)
  end

  return "pnpm test " .. file
end

local function send_command(cmd)
  vim.fn.system({ "kitty", "@", "close-window", "--match", "title:" .. KITTY_WINDOW })

  local logged_cmd = cmd .. " 2>&1 | tee " .. LOG_FILE
  local init = "function fish_title; echo " .. KITTY_WINDOW .. "; end; " .. logged_cmd
  os.execute("kitty --title nvim-test-runner fish -C " .. shell_escape(init) .. " &")
end

function M.test_file()
  send_command(build_command(false))
end

function M.test_nearest()
  send_command(build_command(true))
end

return M
