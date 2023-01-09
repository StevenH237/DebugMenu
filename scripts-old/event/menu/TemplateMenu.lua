-- local Event        = require "necro.event.Event"
-- local Menu         = require "necro.menu.Menu"

-- local Text = require "DebugMenu.i18n.Text"

-- Event.menu.add("menuTemplate", "DebugMenu_templateMenu", function(ev)
--   --[[ev.arg format:
--   {
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
--   ev.menu = menu
-- end)
