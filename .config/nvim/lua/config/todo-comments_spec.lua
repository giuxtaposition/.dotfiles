-- todo-comments_spec.lua — tests for the pure functions in config.todo-comments
-- Run from inside neovim: :luafile %
-- Run headless:           nvim --headless -l lua/config/todo-comments_spec.lua

local t = require("config.spec-runner")
local _ = require("config.todo-comments")._

-- Explicit keyword/prefix fixtures so tests don't depend on module state
local KEYWORDS = { "WARNING", "FIXME", "ISSUE", "TODO", "NOTE", "WARN", "INFO", "BUG", "FIX" }
local PREFIXES = { "^%s*//", "^%s*#", "^%s*%-%-", "^%s*/%*" }

-- ---------------------------------------------------------------------------
-- find_keyword_in_line
-- ---------------------------------------------------------------------------

t.describe("find_keyword_in_line", function()
  t.it("finds TODO with trailing colon", function()
    local kw, cs, ce = _.find_keyword_in_line("  // TODO: fix this", KEYWORDS)
    t.eq(kw, "TODO")
    t.eq(cs, 6)
    t.eq(ce, 9)
  end)

  t.it("finds TODO with trailing space", function()
    local kw = _.find_keyword_in_line("-- TODO fix this", KEYWORDS)
    t.eq(kw, "TODO")
  end)

  t.it("finds TODO at end of line (no trailing char)", function()
    local kw, cs, ce = _.find_keyword_in_line("TODO", KEYWORDS)
    t.eq(kw, "TODO")
    t.eq(cs, 1)
    t.eq(ce, 4)
  end)

  t.it("finds FIXME and returns correct positions", function()
    local kw, cs, ce = _.find_keyword_in_line("-- FIXME: broken", KEYWORDS)
    t.eq(kw, "FIXME")
    t.eq(cs, 4)
    t.eq(ce, 8)
  end)

  t.it("prefers FIXME over FIX (longest first wins)", function()
    local kw = _.find_keyword_in_line("-- FIXME: do it", KEYWORDS)
    t.eq(kw, "FIXME")
  end)

  t.it("returns nil when no keyword present", function()
    local kw = _.find_keyword_in_line("local x = 1 + 2", KEYWORDS)
    t.eq(kw, nil)
  end)

  t.it("does not match keyword embedded in a word (left boundary)", function()
    -- NOTODO: the T is preceded by a word char so %f[%w] does not fire
    local kw = _.find_keyword_in_line("NOTODO: still nothing", KEYWORDS)
    t.eq(kw, nil)
  end)

  t.it("does not match keyword embedded in a word (right boundary)", function()
    -- TODOLIST: the O is followed by a word char so %f[%W] does not fire
    local kw = _.find_keyword_in_line("TODOLIST = {}", KEYWORDS)
    t.eq(kw, nil)
  end)

  t.it("finds NOTE keyword", function()
    local kw = _.find_keyword_in_line("  // NOTE: important", KEYWORDS)
    t.eq(kw, "NOTE")
  end)
end)

-- ---------------------------------------------------------------------------
-- is_comment_regex
-- ---------------------------------------------------------------------------

t.describe("is_comment_regex", function()
  t.it("returns true for // comment line", function()
    -- "  // TODO: fix" — TODO at col 6, before = "  // "
    t.eq(_.is_comment_regex("  // TODO: fix", 6, PREFIXES), true)
  end)

  t.it("returns true for -- comment line", function()
    -- "-- TODO: fix" — TODO at col 4
    t.eq(_.is_comment_regex("-- TODO: fix", 4, PREFIXES), true)
  end)

  t.it("returns true for # comment line", function()
    t.eq(_.is_comment_regex("# TODO: fix", 3, PREFIXES), true)
  end)

  t.it("returns false when keyword is in code, not a comment", function()
    -- "x = TODO: fix" — TODO at col 5, before = "x = "
    t.eq(_.is_comment_regex("x = TODO: fix", 5, PREFIXES), false)
  end)

  t.it("returns false for inline comment after code (not at line start)", function()
    -- "x // TODO" — // is not at the start of the line
    t.eq(_.is_comment_regex("x // TODO", 6, PREFIXES), false)
  end)
end)

-- ---------------------------------------------------------------------------
-- find_next_match
-- ---------------------------------------------------------------------------

t.describe("find_next_match", function()
  local m1 = { row = 0, col = 5 }
  local m2 = { row = 2, col = 3 }
  local m3 = { row = 4, col = 0 }
  local matches = { m1, m2, m3 }

  t.it("returns the first match strictly after the cursor row", function()
    local result = _.find_next_match(matches, 1, 0)
    t.eq(result, m2)
  end)

  t.it("returns the next match on the same row when col is greater", function()
    -- cursor at (2,0): m2 is at (2,3) which is > col 0
    local result = _.find_next_match(matches, 2, 0)
    t.eq(result, m2)
  end)

  t.it("skips a match at the exact cursor position", function()
    -- cursor at (0,5): m1 is at (0,5); col NOT > 5, so skipped
    local result = _.find_next_match(matches, 0, 5)
    t.eq(result, m2)
  end)

  t.it("wraps around to the first match when past the last one", function()
    local result = _.find_next_match(matches, 4, 0)
    t.eq(result, m1)
  end)

  t.it("returns nil for an empty list", function()
    local result = _.find_next_match({}, 0, 0)
    t.eq(result, nil)
  end)
end)

-- ---------------------------------------------------------------------------
-- find_prev_match
-- ---------------------------------------------------------------------------

t.describe("find_prev_match", function()
  local m1 = { row = 0, col = 5 }
  local m2 = { row = 2, col = 3 }
  local m3 = { row = 4, col = 0 }
  local matches = { m1, m2, m3 }

  t.it("returns the closest match before the cursor row", function()
    local result = _.find_prev_match(matches, 3, 0)
    t.eq(result, m2)
  end)

  t.it("returns a match on the same row when col is less", function()
    -- cursor at (2,5): m2 is at (2,3) which is < col 5
    local result = _.find_prev_match(matches, 2, 5)
    t.eq(result, m2)
  end)

  t.it("skips a match at the exact cursor position", function()
    -- cursor at (2,3): m2 is at (2,3); col NOT < 3, so skipped
    local result = _.find_prev_match(matches, 2, 3)
    t.eq(result, m1)
  end)

  t.it("wraps around to the last match when before the first one", function()
    local result = _.find_prev_match(matches, 0, 0)
    t.eq(result, m3)
  end)

  t.it("returns nil for an empty list", function()
    local result = _.find_prev_match({}, 0, 0)
    t.eq(result, nil)
  end)
end)

-- ---------------------------------------------------------------------------
-- parse_ripgrep_output
-- ---------------------------------------------------------------------------

t.describe("parse_ripgrep_output", function()
  t.it("parses a valid ripgrep line", function()
    local items = _.parse_ripgrep_output("src/app.ts:10:5:  // TODO: fix this\n", KEYWORDS)
    t.eq(#items, 1)
    t.eq(items[1].filename, "src/app.ts")
    t.eq(items[1].lnum, 10)
    t.eq(items[1].col, 5)
  end)

  t.it("uses the detected keyword as the text prefix", function()
    local items = _.parse_ripgrep_output("a.ts:1:1:-- FIXME: broken\n", KEYWORDS)
    t.eq(items[1].text:sub(1, 5), "FIXME")
  end)

  t.it("falls back to TODO prefix when no keyword is detected in text", function()
    local items = _.parse_ripgrep_output("a.ts:1:1:just some line\n", KEYWORDS)
    t.eq(items[1].text:sub(1, 4), "TODO")
  end)

  t.it("returns empty list for empty input", function()
    t.deep_eq(_.parse_ripgrep_output("", KEYWORDS), {})
  end)

  t.it("skips malformed lines with no digit columns", function()
    t.deep_eq(_.parse_ripgrep_output("not a valid ripgrep line\n", KEYWORDS), {})
  end)

  t.it("parses multiple lines", function()
    local stdout = "a.ts:1:1:-- TODO: one\nb.ts:2:3:-- NOTE: two\n"
    local items = _.parse_ripgrep_output(stdout, KEYWORDS)
    t.eq(#items, 2)
    t.eq(items[1].filename, "a.ts")
    t.eq(items[2].filename, "b.ts")
  end)
end)

-- ---------------------------------------------------------------------------
-- Summary
-- ---------------------------------------------------------------------------

t.done()
