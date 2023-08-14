local status, windows = pcall(require, "windows")
if not status then
	return
end

windows.setup()
