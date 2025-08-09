-- Custom magick plugin that handles multi-frame HEIC files
-- Based on yazi's built-in magick plugin with HEIC fix

local M = {}

function M:peek(job)
	ya.dbg("HEIC peek called for: " .. tostring(job.file.url))
	local cache = ya.file_cache(job)
	if not cache then
		ya.dbg("No cache file found")
		return
	end

	if not fs.cha(cache) then
		ya.dbg("Cache file does not exist: " .. tostring(cache))
		return
	end

	ya.dbg("Showing cached image: " .. tostring(cache))
	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek() end

function M:preload(job)
	ya.dbg("HEIC preload called for: " .. tostring(job.file.url))
	local cache = ya.file_cache(job)
	if not cache then
		ya.dbg("No cache path available")
		return false
	end

	if fs.cha(cache) then
		ya.dbg("Cache already exists: " .. tostring(cache))
		return true
	end

	local input_path = tostring(job.file.url)
	ya.dbg("Original input path: " .. input_path)

	-- For HEIC files, append [0] to get only the first frame
	if string.match(input_path:lower(), "%.heic$") then
		input_path = input_path .. "[0]"
		ya.dbg("Modified input path for HEIC: " .. input_path)
	end

	ya.dbg("Running magick command...")
	local child, code = Command("magick"):arg({
		input_path,
		"-density",
		"200",
		"-resize",
		"1200x1600>", -- Use the full max dimensions from config
		"-quality",
		"90", -- Higher quality
		"JPG:" .. tostring(cache),
	}):spawn()

	if not child then
		ya.err("spawn `magick` command failed with code: " .. tostring(code))
		return false
	end

	local status = child:wait()
	ya.dbg("Magick command completed. Success: " .. tostring(status and status.success))
	if status and status.success then
		ya.dbg("Cache file created successfully: " .. tostring(cache))
	else
		ya.err("Magick command failed")
	end

	return status and status.success or false
end

return M
