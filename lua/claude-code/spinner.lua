local M = {}
local config = {}

-- Configure module with user options
function M.setup(global_config)
	-- Store reference to global config
	config = global_config
end

local id = "claude_code_spinner"
local title = "Claude Code"

local timer = nil
local active = false
local stop_icons = {
	[vim.log.levels.INFO] = " ",
	[vim.log.levels.WARN] = " ",
	[vim.log.levels.ERROR] = " ",
}

local function tick(msg)
	vim.notify(msg, vim.log.levels.INFO, { id = id, title = title, icon = Snacks.util.spinner() })
end

function M.start(msg)
	if active then
		return
	end
	active = true
	timer = vim.loop.new_timer()
	if timer == nil then
		return
	end
	timer:start(0, 100, function()
		vim.schedule(function()
			tick(msg)
		end)
	end)
end

function M.stop(msg, level)
	if not active then
		return
	end
	active = false
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
	if msg then
		vim.notify(msg, level, { id = id, title = title, timeout = config.spinner_timeout, icon = stop_icons[level] })
	else
		vim.notify("", level, { id = id, title = title, timeout = 1, icon = stop_icons[level] })
	end
end

return M
