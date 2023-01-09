local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Utilities = require "system.utils.Utilities"

local DMMisc = require "DebugMenu.Misc"

local Text = require "DebugMenu.i18n.Text"

Event.menu.add("menuEntityList", "DebugMenu_entityList", function(ev)
  --[[ev.arg format:
  {
    callback = function(int) end,
    entities = {}? -- list of IDs,
  }
  ]]

  -- Get the full list of entities
  local entities = {}
  if ev.arg.entities then
    entities = Utilities.map(ev.arg.entities, function(T)
      if Entities.entityExists(T) then
        return Entities.getEntityByID(T)
      end
    end)
  else
    for e in Entities.entitiesWithComponents({}) do
      entities[#entities + 1] = e
    end
  end

  local menu = {}
  local entries = {}

  for i, v in ipairs(entities) do
    entries[#entries + 1] = {
      id = "entity_" .. v.id,
      label = DMMisc.labelEntity(v, v.id),
      action = function() ev.arg.callback(v.id) end
    }
  end

  entries[#entries + 1] = {
    height = 0
  }

  entries[#entries + 1] = {
    id = "_done",
    label = Text.Menu.Close,
    action = Menu.close
  }

  menu.entries = entries
  menu.label = Text.Menu.EntityList.Title
  menu.escapeAction = Menu.close
  menu.searchable = true
  ev.menu = menu
end)
