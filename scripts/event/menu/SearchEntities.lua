local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextPrompt = require "necro.render.ui.TextPrompt"

local Text = require "DebugMenu.i18n.Text"

local function searchEntities(params)
end

Event.menu.add("menuTemplate", "DebugMenu_searchEntities", function(ev)
  if not ev.arg then
    -- ev.arg format:
    ev.arg = {
      withComponents = {},
      withoutComponents = {},
      name = ""
    }
  end

  local entName = TextPrompt.menuEntry {
    id = "entName",
    get = function() return ev.arg.name or "" end,
    set = function(value) ev.arg.name = value end,
    label = Text.Menu.SearchEntities.Name,
    autoSelect = true
  }

  entName.actionHint = "Modify"
  entName.specialActionHint = "Reset"

  local menu = {}
  local entries = {
    entName,
    {
      id = "components",
      label = function() return Text.Menu.SearchEntities.Components(#ev.arg.withComponents, #ev.arg.withoutComponents) end,
      action = function() --[[open a menu]] end,
      actionHint = "Select components to require",
    },
    {
      height = 0
    },
    {
      id = "_done",
      label = Text.Menu.Close,
      action = function() searchEntities(ev.arg) end
    }
  }

  menu.entries = entries
  menu.label = Text.Menu.SearchEntities.Title
  menu.escapeAction = Menu.close
  ev.menu = menu
end)
