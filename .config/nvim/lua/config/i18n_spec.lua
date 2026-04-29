-- i18n_spec.lua — tests for the pure functions in config.i18n
-- Run from inside neovim: :luafile %
-- Run headless:           nvim --headless -l lua/config/i18n_spec.lua

local _ = require("config.i18n")._
local t = require("config.spec-runner")
local describe, it, eq, deep_eq = t.describe, t.it, t.eq, t.deep_eq

-- ---------------------------------------------------------------------------
-- flatten
-- ---------------------------------------------------------------------------

describe("flatten", function()
  it("flattens nested table into dot-separated keys", function()
    local result = _.flatten({ a = { b = { c = "value" } } })
    eq(result["a.b.c"], "value")
  end)

  it("preserves top-level string values", function()
    local result = _.flatten({ hello = "world" })
    eq(result["hello"], "world")
  end)

  it("coerces non-string values to string", function()
    local result = _.flatten({ count = 42 })
    eq(result["count"], "42")
  end)

  it("handles empty table", function()
    local result = _.flatten({})
    eq(next(result), nil, "expected empty result")
  end)

  it("handles multiple sibling keys at same level", function()
    local result = _.flatten({ a = "1", b = "2" })
    eq(result["a"], "1")
    eq(result["b"], "2")
  end)
end)

-- ---------------------------------------------------------------------------
-- find_keys_on_line
-- ---------------------------------------------------------------------------

describe("find_keys_on_line", function()
  local function keys_of(line)
    local ks = {}
    for _, m in ipairs(_.find_keys_on_line(line)) do
      table.insert(ks, m.key)
    end
    return ks
  end

  it("finds t() with single quotes", function()
    deep_eq(keys_of("  t('some.key')"), { "some.key" })
  end)

  it("finds t() with double quotes", function()
    deep_eq(keys_of('  t("some.key")'), { "some.key" })
  end)

  it("finds t() at start of line", function()
    deep_eq(keys_of("t('start.key')"), { "start.key" })
  end)

  it("finds multiple t() calls on the same line", function()
    deep_eq(keys_of("t('a') + t('b')"), { "a", "b" })
  end)

  it("finds i18nKey='key'", function()
    deep_eq(keys_of("i18nKey='some.key'"), { "some.key" })
  end)

  it('finds i18nKey="key"', function()
    deep_eq(keys_of('i18nKey="some.key"'), { "some.key" })
  end)

  it("finds i18nKey={'key'}", function()
    deep_eq(keys_of("i18nKey={'some.key'}"), { "some.key" })
  end)

  it('finds i18nKey={"key"}', function()
    deep_eq(keys_of('i18nKey={"some.key"}'), { "some.key" })
  end)

  it("does not match word-prefixed t() like at('key')", function()
    deep_eq(keys_of("at('key')"), {})
  end)

  it("returns empty for lines with no keys", function()
    deep_eq(keys_of("const x = 1"), {})
  end)

  it("returns empty for plain string", function()
    deep_eq(keys_of("hello world"), {})
  end)
end)

-- ---------------------------------------------------------------------------
-- wrap
-- ---------------------------------------------------------------------------

describe("wrap", function()
  it("returns text shorter than width as single element", function()
    deep_eq(_.wrap("hello", 20), { "hello" })
  end)

  it("hard-wraps at exact width boundary", function()
    deep_eq(_.wrap("abcdef", 3), { "abc", "def" })
  end)

  it("splits on existing newlines", function()
    deep_eq(_.wrap("line1\nline2", 20), { "line1", "line2" })
  end)

  it("combines newline splitting and hard wrapping", function()
    deep_eq(_.wrap("abcdef\nghijkl", 3), { "abc", "def", "ghi", "jkl" })
  end)

  it("handles empty string", function()
    deep_eq(_.wrap("", 10), { "" })
  end)

  it("handles text exactly at width", function()
    deep_eq(_.wrap("abc", 3), { "abc" })
  end)
end)

-- ---------------------------------------------------------------------------
-- build_popup_lines
-- ---------------------------------------------------------------------------

describe("build_popup_lines", function()
  it("produces key line and value line for short values", function()
    local lines, _ = _.build_popup_lines("common.ok", "OK", 88)
    eq(lines[1], "Key:   common.ok")
    eq(lines[2], "Value: OK")
    eq(#lines, 2)
  end)

  it("wraps long value onto continuation lines with indent", function()
    local long = string.rep("x", 90)
    local lines, _ = _.build_popup_lines("k", long, 88)
    -- "Value: " is 7 chars, so available = 88 - 7 = 81
    eq(#lines[2], 88, "first value line fills available width")
    eq(lines[3]:sub(1, 7), "       ", "continuation line is indented")
  end)

  it("returns width equal to the longest line", function()
    local lines, width = _.build_popup_lines("k", "short", 88)
    local expected = math.max(#lines[1], #lines[2])
    eq(width, expected)
  end)

  it("splits value on newlines before wrapping", function()
    local lines, _ = _.build_popup_lines("k", "first\nsecond", 88)
    eq(lines[2], "Value: first")
    eq(lines[3], "       second")
    eq(#lines, 3)
  end)
end)

t.done()
