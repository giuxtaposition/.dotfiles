local w = require("wezterm")

local M = {}

local last_update = 0
local stored_playing = ""

M.wait = function(throttle, last_update)
  local current_time = os.time()
  return current_time - last_update < throttle
end

M.get_currently_playing = function(max_width, throttle)
  if M.wait(throttle, last_update) then
    return stored_playing
  end

  local success, stdout, stderr = w.run_child_process({
    "playerctl",
    "--player=spotify",
    "metadata",
    "--format",
    "{{artist}} - {{title}}",
  })

  if not success then
    w.log_error("Failed to get currently playing song: " .. stderr)
    return ""
  end

  stored_playing = stdout
  last_update = os.time()

  return stdout
end

return M
