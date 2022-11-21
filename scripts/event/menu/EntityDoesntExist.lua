local Event = require "necro.event.Event"
local Menu  = require "necro.menu.Menu"

local Text = require "DebugMenu.i18n.Text"

Event.menu.add("menuEntityDoesntExist", "DebugMenu_entityDoesntExist", function(ev)
  --[[ev.arg format:
  {
    id = 0
  }
  ]]

  local menu = {}
  local entries = {
    {
      id = "label",
      label = Text.Menu.EntityPicker.Label.NonExistent(ev.arg.id),
      action = function() end,
    },
    {
      height = 0
    },
    {
      id = "_done",
      label = Text.Menu.Close,
      action = Menu.close
    }
  }

  menu.entries = entries
  menu.label = Text.Menu.EntityDoesntExist.Title
  menu.escapeAction = Menu.close
  ev.menu = menu
end)
