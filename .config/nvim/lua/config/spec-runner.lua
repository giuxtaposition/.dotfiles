-- Minimal test runner for neovim Lua specs.
-- Usage:
--   local runner = require("config.spec-runner")
--   runner.describe("suite", function() ... end)
--   runner.it("case", function() ... end)
--   runner.eq(got, expected)
--   runner.deep_eq(got, expected)
--   runner.done()   -- prints summary and exits with code 1 on failure

local M = {}

local results = { pass = 0, fail = 0 }

function M.describe(suite, fn)
  print("\n" .. suite)
  fn()
end

function M.it(name, fn)
  local ok, err = pcall(fn)
  if ok then
    results.pass = results.pass + 1
    print("  ✓ " .. name)
  else
    results.fail = results.fail + 1
    print("  ✗ " .. name .. "\n    " .. tostring(err))
  end
end

function M.eq(got, expected, label)
  if got ~= expected then
    error(
      string.format("%s\n      expected: %s\n      got:      %s", label or "", vim.inspect(expected), vim.inspect(got)),
      2
    )
  end
end

function M.deep_eq(got, expected, label)
  if not vim.deep_equal(got, expected) then
    error(
      string.format("%s\n      expected: %s\n      got:      %s", label or "", vim.inspect(expected), vim.inspect(got)),
      2
    )
  end
end

function M.done()
  print(string.format("\n%d passed, %d failed", results.pass, results.fail))
  if results.fail > 0 then
    vim.cmd("cquit 1")
  end
end

return M
