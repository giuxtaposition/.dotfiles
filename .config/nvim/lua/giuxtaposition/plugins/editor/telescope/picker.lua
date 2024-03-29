local M = {}

local telescopeUtilities = require("telescope.utils")
local telescopeMakeEntryModule = require("telescope.make_entry")
local plenaryStrings = require("plenary.strings")
local devIcons = require("nvim-web-devicons")
local telescopeEntryDisplayModule = require("telescope.pickers.entry_display")

local fileTypeIconWidth = plenaryStrings.strdisplaywidth(devIcons.get_icon("fname", { default = true }))

function M.getPathAndTail(fileName)
  -- Get the Tail
  local bufferNameTail = telescopeUtilities.path_tail(fileName)

  -- Now remove the tail from the Full Path
  local pathWithoutTail = require("plenary.strings").truncate(fileName, #fileName - #bufferNameTail, "")

  -- Apply truncation and other pertaining modifications to the path according to Telescope path rules
  local pathToDisplay = telescopeUtilities.transform_path({
    path_display = { "truncate" },
  }, pathWithoutTail)

  -- Return as Tuple
  return bufferNameTail, pathToDisplay
end

function M.filesPicker(pickerAndOptions)
  local options = pickerAndOptions.options or {}
  local originalEntryMaker = telescopeMakeEntryModule.gen_from_file(options)

  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)
    local displayer = telescopeEntryDisplayModule.create({
      separator = "", -- Telescope will use this separator between each entry item
      items = {
        { width = fileTypeIconWidth },
        { width = nil },
        { remaining = true },
      },
    })
    originalEntryTable.display = function(entry)
      local tail, pathToDisplay = M.getPathAndTail(entry.value)
      local tailForDisplay = tail .. " "
      local icon, iconHighlight = telescopeUtilities.get_devicons(tail)
      return displayer({
        { icon, iconHighlight },
        tailForDisplay,
        { pathToDisplay, "TelescopeResultsComment" },
      })
    end

    return originalEntryTable
  end

  -- Finally, check which file picker was requested and open it with its associated options
  if pickerAndOptions.picker == "find_files" then
    require("telescope.builtin").find_files(options)
  elseif pickerAndOptions.picker == "git_files" then
    require("telescope.builtin").git_files(options)
  elseif pickerAndOptions.picker == "oldfiles" then
    require("telescope.builtin").oldfiles(options)
  elseif pickerAndOptions.picker == "" then
    print("Picker was not specified")
  else
    print("Picker is not supported")
  end
end

function M.grepPicker(pickerAndOptions)
  local options = pickerAndOptions.options or {}

  local originalEntryMaker = telescopeMakeEntryModule.gen_from_vimgrep(options)
  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)
    local displayer = telescopeEntryDisplayModule.create({
      separator = "", -- Telescope will use this separator between each entry item
      items = {
        { width = fileTypeIconWidth },
        { width = nil },
        { width = nil }, -- Maximum path size, keep it short
        { remaining = true },
      },
    })

    originalEntryTable.display = function(entry)
      local tail, pathToDisplay = M.getPathAndTail(entry.filename)
      local icon, iconHighlight = telescopeUtilities.get_devicons(tail)
      local coordinates = ""

      if not options.disable_coordinates then
        if entry.lnum then
          if entry.col then
            coordinates = string.format(" -> %s:%s", entry.lnum, entry.col)
          else
            coordinates = string.format(" -> %s", entry.lnum)
          end
        end
      end

      -- Append coordinates to tail
      tail = tail .. coordinates

      -- Add an extra space to the tail so that it looks nicely separated from the path
      local tailForDisplay = tail .. " "

      -- Encode text if necessary
      local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text
      return displayer({
        { icon, iconHighlight },
        tailForDisplay,
        { pathToDisplay, "TelescopeResultsComment" },
        text,
      })
    end

    return originalEntryTable
  end

  if pickerAndOptions.picker == "live_grep" then
    require("telescope.builtin").live_grep(options)
  elseif pickerAndOptions.picker == "grep_string" then
    require("telescope.builtin").grep_string(options)
  elseif pickerAndOptions.picker == "" then
    print("Picker was not specified")
  else
    print("Picker is not supported by Pretty Grep Picker")
  end
end

return M
