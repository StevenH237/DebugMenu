-- local Event        = require "necro.event.Event"
-- local Menu         = require "necro.menu.Menu"

-- local Text = require "DebugMenu.i18n.Text"

-- Event.menu.add("menuEntityList", "DebugMenu_entityList", function(ev)
--   --[[ev.arg format:
--   {
--     entities = {} -- list of IDs
--   }
--   ]]

--   local menu = {}
--   local entries = {
--     {
--       id = "templateItem",
--       label = "Test",
--       action = function() end,
--     },
--     {
--       height = 0
--     },
--     {
--       id = "_done",
--       label = Text.Menu.Close,
--       action = Menu.close
--     }
--   }

--   menu.entries = entries
--   menu.label = Text.Menu.Template.Title
--   menu.escapeAction = Menu.close
--   menu.searchable = true
--   ev.menu = menu
-- end)
