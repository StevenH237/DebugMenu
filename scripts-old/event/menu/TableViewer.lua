local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Utilities = require "system.utils.Utilities"

local DMMisc = require "DebugMenu.Misc"

local Text = require "DebugMenu.i18n.Text"

local function openAsEntity(id)
  if Entities.entityExists(id) then
    local ent = Entities.getEntityByID(id)

    Menu.open("DebugMenu_entityViewer", {
      entity = ent,
      label = DMMisc.labelEntity(ent, id)
    })
  else
    Menu.open("DebugMenu_entityDoesntExist", {
      id = id
    })
  end
end

local function suffix(k)
  if type(k) == "number" then
    return "[" .. k .. "]"
  else
    return "." .. k
  end
end

Event.menu.add("menuTable", "DebugMenu_tableViewer", function(ev)
  --[[ev.arg format:
  {
    table = {},
    prefix = ""
  }
  ]]

  local menu = {}
  local entries = {
    {
      id = "prefix",
      label = ev.arg.prefix
    },
    {
      height = 0
    }
  }

  for ok, v in Utilities.sortedPairs(ev.arg.table) do
    local entry = {
      id = "index_" .. ok
    }

    local k = ok
    if type(ok) == "number" then
      k = "[" .. ok .. "]"
    end

    if type(v) ~= "table" then
      entry.label = string.format("%s: %s", k, Utilities.inspect(v))
      entry.action = function() end
      if type(v) == "number" and v == math.floor(v) and v > 0 then
        entry.specialAction = function() openAsEntity(v) end
      end
    else
      local any = false
      for k2, v2 in Utilities.sortedPairs(v) do
        any = true
        break
      end

      if any then
        entry.label = string.format("%s: {...}", k)
        entry.action = function()
          Menu.open("DebugMenu_tableViewer", {
            table = v,
            prefix = ev.arg.prefix .. suffix(ok)
          })
        end
        entry.specialAction = function() print(v) end
      else
        entry.label = string.format("%s: {}", k)
        entry.action = function() end
      end
    end

    entries[#entries + 1] = entry
  end

  menu.entries = entries
  menu.label = Text.Menu.TableViewer.Title
  menu.escapeAction = Menu.close
  ev.menu = menu
end)
