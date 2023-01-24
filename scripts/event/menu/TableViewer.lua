local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Utilities = require "system.utils.Utilities"

local DMMisc = require "DebugMenu.Misc"
local MMHelper = require "MenuMod.Helper"

local Text = require "DebugMenu.i18n.Text"

local function labelEntity(ent, id)
  if not ent then
    return Text.Menu.EntityViewer.Label.NonExistent(id)
  elseif ent.item and ent.item.equipped then
    local holder = Entities.getEntityByID(ent.item.holder)
    return Text.Menu.EntityViewer.Label.Inventory(ent.name, ent.id, holder.name, holder.id)
  elseif ent.position then
    return Text.Menu.EntityViewer.Label.WithPosition(ent.name, ent.id, ent.position.x, ent.position.y)
  else
    return Text.Menu.EntityViewer.Label.Default(ent.name, ent.id)
  end
end

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
    prefix = "",
    component = "",
    isEntTable = false
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
      if type(v) == "number" then
        if ev.arg.isEntTable then
          entry.label = string.format("%s: %s", k, labelEntity(Entities.getEntityByID(v), v))
          entry.action = function() openAsEntity(v) end
          entry.actionHint = "View entity"
        else
          entry.label = string.format("%s: %s", k, Utilities.inspect(v))
          entry.action = function() end
          if ev.arg.isEntTable == nil then
            entry.specialAction = function() openAsEntity(v) end
            entry.specialActionHint = "View as entity"
          end
        end
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
            prefix = ev.arg.prefix .. suffix(ok),
            component = ev.arg.component,
            isEntTable = ev.arg.isEntTable
          })
        end
        entry.actionHint = "View table"
        entry.specialAction = function() log.info(Utilities.inspect(v)) end
        entry.specialActionHint = "Print table to log"
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

  MMHelper.addControlHint(ev)
end)
