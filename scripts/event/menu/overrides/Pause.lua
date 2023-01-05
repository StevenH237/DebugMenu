local Event = require "necro.event.Event"
local Menu  = require "necro.menu.Menu"

local Text = require "DebugMenu.i18n.Text"

-- Event.menu.override("pause", 1, function(func, ev)
--   -- Run regular menu event first
--   func(ev)

--   -- Determine position of customize button
--   local customize = 0

--   for i, v in ipairs(ev.menu.entries) do
--     if v.id == "customize" then
--       customize = i
--       break
--     end
--   end

--   -- Add debug menu entry
--   table.insert(ev.menu.entries, customize + 1, {
--     id = "debug",
--     label = Text.Menu.Debug.Title,
--     action = function()
--       Menu.open("DebugMenu_debugMenu", {
--         wasPaused = true
--       })
--     end,
--   })
-- end)
