local Event        = require "necro.event.Event"
local Menu         = require "necro.menu.Menu"
local StateControl = require "necro.client.StateControl"

local Text = require "DebugMenu.i18n.Text"

-- This menu is normally inaccessible! I'm just tossing it back in when I need something quick.

local menuData = {
}

Event.menu.add("menuDebug", "DebugMenu_debugMenu", function(ev)
  --[[ev.arg format:
  {}
  ]]

  local menu = {}
  local entries = {
    {
      id = "blah",
      label = "Print this selection",
      action = function()
        print(Menu.getSelectedEntry())
      end,
      controlHint = "{a} Print"
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
  menu.label = Text.Menu.Debug.Title
  ev.menu = menu
end)
