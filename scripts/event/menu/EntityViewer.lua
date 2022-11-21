local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Try       = require "system.utils.Try"
local Utilities = require "system.utils.Utilities"

local DMMisc = require "DebugMenu.Misc"

local Text = require "DebugMenu.i18n.Text"

local function selectComponent(i, arg)
  arg.componentSelected = i

  local name = arg.componentList[i]
  arg.componentName = name

  local comp = arg.entity[name]
  arg.componentData = comp

  Menu.update()
end

local function selectPriorComponent(arg)
  local now = arg.componentSelected - 1
  if now == 0 then
    now = #(arg.componentList)
  end

  selectComponent(now, arg)
end

local function selectNextComponent(arg)
  local now = arg.componentSelected + 1
  if now == #(arg.componentList) + 1 then
    now = 1
  end

  selectComponent(now, arg)
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

Event.menu.add("menuEntityViewer", "DebugMenu_entityViewer", function(ev)
  --[[ev.arg format:
  {
    componentData = {},
    componentList = {},
    componentName = "",
    componentSelected = 0,
    entity = { -- Entity#237 },
    label = "Entity#237 at 0, 0",
  }
  ]]

  -- Did the entity change? We'll need to regen the component lists if so.
  if ev.arg.componentList == nil then
    local ent = ev.arg.entity

    ev.arg.componentData = {}
    ev.arg.componentList = {}
    ev.arg.componentName = ""
    ev.arg.componentSelected = 0

    for k, v in Utilities.sortedPairs(ent._components) do
      if type(v) == "table" or type(v) == "userdata" then
        table.insert(ev.arg.componentList, k)
      end
    end

    selectComponent(1, ev.arg)
  end

  local menu = {}
  local entries = {
    {
      id = "entityLabel",
      label = ev.arg.label
    },
    {
      id = "componentPicker",
      label = ev.arg.componentName,
      action = function() end, -- eventually this should lead to a component picker
      leftAction = function() selectPriorComponent(ev.arg) end,
      rightAction = function() selectNextComponent(ev.arg) end,
    },
    {
      height = 0
    }
  }

  -- Now add each of the component's fields to the menu
  if not pcall(function() for k, dv in Utilities.sortedPairs(ev.arg.componentData._defaults) do
      local v = ev.arg.componentData[k]

      local entry = {
        id = "field_" .. k
      }

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
              prefix = ev.arg.componentName .. "." .. k
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
  end) then
    entries[#entries + 1] = {
      id = "marker",
      label = "(Marker component - no fields)"
      -- action intentionally omitted to grey out the item
    }
  end

  -- And the gap and done buttons
  entries[#entries + 1] = {
    height = 0
  }

  entries[#entries + 1] = {
    id = "_done",
    label = Text.Menu.Close,
    action = Menu.close
  }

  menu.entries = entries
  menu.label = Text.Menu.EntityViewer.Title
  menu.escapeAction = Menu.close
  ev.menu = menu
end)
