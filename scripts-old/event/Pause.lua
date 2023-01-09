local Event = require "necro.event.Event"

local isPaused = false

Event.gameStatePause.add("pauseChecker", { order = "menu", sequence = 1 }, function(ev)
  isPaused = true
end)

Event.gameStateUnpause.add("unpauseChecker", { order = "menu", sequence = 1 }, function(ev)
  isPaused = false
end)

return {
  isPaused = function() return isPaused end
}
