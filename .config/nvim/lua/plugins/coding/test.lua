local set_keymap = require("config.util.keys").set

vim.pack.add({ {
  src = "https://github.com/vim-test/vim-test",
} })

-- The repos here use pnpm, and vim-test defaults to npx.
vim.g["test#javascript#jest#executable"] = "pnpm jest"
vim.g["test#javascript#vitest#executable"] = "pnpm vitest"

local runner_pane = nil

local function is_runner_alive()
  if not runner_pane then
    return false
  end
  return vim.list_contains(vim.fn.systemlist({ "tmux", "list-panes", "-a", "-F", "#{pane_id}" }), runner_pane)
end

-- The bundled vimux strategy types the command into a shell, which costs the
-- fish greeting and a prompt line on every run. tmux can own the process
-- instead: the pane runs the test command and nothing else, and respawning the
-- same pane keeps re-runs in place.
local function run_in_tmux_pane(cmd)
  -- The trailing `cat` blocks on stdin so the results stay on screen. A pane
  -- whose command exits is cleared down to "Pane is dead" even with
  -- remain-on-exit, and holding it open this way needs no shell prompt.
  local held = cmd .. "; cat"

  if is_runner_alive() then
    vim.fn.system({ "tmux", "respawn-pane", "-k", "-t", runner_pane, held })
    return
  end

  -- stylua: ignore
  runner_pane = vim.trim(vim.fn.system({
    "tmux", "split-window", "-d", "-l", "40%", "-P", "-F", "#{pane_id}",
    "-c", vim.fn.getcwd(), held,
  }))
end

vim.g["test#custom_strategies"] = { tmux = run_in_tmux_pane }
vim.g["test#strategy"] = "tmux"

set_keymap("n", "<leader>ta", "<cmd>TestSuite<cr>", "Test all")
set_keymap("n", "<leader>tf", "<cmd>TestFile<cr>", "Test file")
set_keymap("n", "<leader>tn", "<cmd>TestNearest<cr>", "Test nearest")
set_keymap("n", "<leader>tl", "<cmd>TestLast<cr>", "Test last (re-run)")
set_keymap("n", "<leader>tv", "<cmd>TestVisit<cr>", "Visit last test file")
set_keymap("n", "<leader>tz", function()
  if is_runner_alive() then
    vim.fn.system({ "tmux", "resize-pane", "-Z", "-t", runner_pane })
  end
end, "Zoom test pane")

set_keymap("n", "<leader>tq", function()
  if is_runner_alive() then
    vim.fn.system({ "tmux", "kill-pane", "-t", runner_pane })
  end
  runner_pane = nil
end, "Close test pane")

-- vim-test has no folder command; TestSuite passes extra args to the runner,
-- and both jest and vitest read a positional path as a filter.
set_keymap("n", "<leader>td", function()
  local cur_dir = vim.fn.expand("%:.:h")
  if cur_dir == "" then
    cur_dir = "."
  end
  local cmd = string.format(
    "{ echo %s; fd --type d --hidden --exclude .git --exclude node_modules; } | awk '!seen[$0]++'",
    vim.fn.shellescape(cur_dir)
  )

  require("fzf-lua").fzf_exec(cmd, {
    prompt = " ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          vim.cmd("TestSuite " .. vim.fn.fnameescape(selected[1]))
        end
      end,
    },
  })
end, "Test folder (pick)")
