local InfiniteHealth = {}

local running = false
local thread

-- you pass moveitems in, so the module doesn't depend on globals
function InfiniteHealth.start(moveitems, useTaskSpawn)
	if running then return end
	running = true

	local function healthLoop()
		while running do
			moveitems:InvokeServer(101, 9, true)
			moveitems:InvokeServer(9, 101, true)
			task.wait()
		end
	end

	if useTaskSpawn then
		thread = task.spawn(healthLoop)
	else
		healthLoop()
	end
end

function InfiniteHealth.stop()
	running = false
	thread = nil
end

return InfiniteHealth
