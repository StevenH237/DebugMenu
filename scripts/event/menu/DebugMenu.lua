local Event        = require "necro.event.Event"
local Menu         = require "necro.menu.Menu"
local StateControl = require "necro.client.StateControl"

local Text = require "DebugMenu.i18n.Text"

local function getExitFunction(wasPaused)
  return function()
    Menu.close()
    if (not wasPaused) and StateControl.isPauseAllowed() then
      StateControl.unpause()
    end
  end
end

local menuData = {
}

Event.menu.add("menuDebug", "DebugMenu_debugMenu", function(ev)
  --[[ev.arg format:
  {
    wasPaused = true
  }
  ]]

  local menu = {}
  local entries = {
    {
      id = "templateItem",
      label = Text.Menu.EntityPicker.Title,
      action = function()
        Menu.open("DebugMenu_entityPicker", {})
      end,
    },
    {
      height = 0
    },
    {
      id = "_done",
      label = Text.Menu.Close,
      action = getExitFunction(ev.arg.wasPaused)
    }
  }

  menu.entries = entries
  menu.label = Text.Menu.Debug.Title
  menu.escapeAction = getExitFunction(ev.arg.wasPaused)
  ev.menu = menu
end)
