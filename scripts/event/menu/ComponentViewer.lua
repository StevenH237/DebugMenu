local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Try       = require "system.utils.Try"
local Utilities = require "system.utils.Utilities"

local DMEntComponents = require "DebugMenu.data.EntityComponents"

local MMHelper = require "MenuMod.Helper"

local NixLib = require "NixLib.NixLib"

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
      label = labelEntity(ent, id)
    })
  else
    Menu.open("DebugMenu_entityDoesntExist", {
      id = id
    })
  end
end

Event.menu.add("menuComponentViewer", "DebugMenu_componentViewer", function(ev)
  --[[ev.arg format:
  {
    fieldData = {},
    fieldList = {},
    fieldName = "",
    fieldSelected = 0,
    component = { -- component data },
    selected = nil or "",
    controls = nil or ""
  }
  ]]

  -- Did the entity change? We'll need to regen the component lists if so.
  if ev.arg.fieldList == nil then
    local ent = ev.arg.entity

    ev.arg.fieldData = {}
    ev.arg.fieldList = {}
    ev.arg.fieldName = ""
    ev.arg.fieldSelected = 0

    ev.arg.fieldList = Utilities.map()

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
      action = function() Menu.open("DebugMenu_entityComponentList", {
          entity = ev.arg.entity,
          componentList = ev.arg.componentList,
          callback = function(v, i)
            ev.arg.componentName = v
            ev.arg.componentSelected = i
            ev.arg.componentData = ev.arg.entity[v]
            Menu.update()
          end
        })
      end, -- eventually this should lead to a component picker
      leftAction = function() selectPriorComponent(ev.arg) end,
      rightAction = function() selectNextComponent(ev.arg) end,
    },
    {
      height = 0
    }
  }

  local componentSpec = NixLib.getComponent(ev.arg.componentName)

  if #componentSpec.fields == 0 then
    entries[#entries + 1] = {
      id = "marker",
      label = "(Marker component - no fields)"
      -- action intentionally omitted to grey out the item
    }
  else
    local fieldTypes = {}
    local enums = {}
    for i, v in ipairs(componentSpec.fields) do
      fieldTypes[v.name] = v.type
      enums[v.name] = v.enum
    end

    -- Now add each of the component's fields to the menu
    for k, dv in Utilities.sortedPairs(ev.arg.componentData._defaults) do
      local v = ev.arg.componentData[k]

      local entry = {
        id = "field_" .. k
      }

      if fieldTypes[k] == "table" then
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
              prefix = ev.arg.componentName .. "." .. k,
              component = ev.arg.componentName .. "." .. k,
              isEntTable = DMEntComponents.isEntityTable(ev.arg.componentName .. "." .. k, v)
            })
          end
          entry.actionHint = "View this table"
          entry.specialAction = function() log.info(v) end
          entry.specialActionHint = "Print table to log"
        else
          entry.label = string.format("%s: {}", k)
          entry.action = function() end
        end
      elseif fieldTypes[k] == "entityID" then
        if v == 0 then
          entry.label = string.format("%s: (None)", k)
          entry.action = function() end
        else
          entry.label = string.format("%s: %s", k, labelEntity(Entities.getEntityByID(v), v))
          entry.action = function() openAsEntity(v) end
          entry.actionHint = "View this entity"
        end
      elseif fieldTypes[k] == "string" then
        entry.label = string.format("%s: %s", k, Utilities.inspect(v))
        entry.action = function() end
        entry.specialAction = function() log.info(v) end
        entry.specialActionHint = "Print string to log"
      elseif enums[k] then
        local enum = enums[k]
        local value
        if not pcall(function() value = enum.inspect(v) end) then
          value = enum.names[v]
        end
        entry.label = string.format("%s: %s", k, value)
        entry.action = function() end
        entry.specialAction = function() log.info(value) end
        entry.specialActionHint = "Print value to log"
      else
        entry.label = string.format("%s: %s", k, Utilities.inspect(v))
        entry.action = function() end
      end

      entries[#entries + 1] = entry
    end
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

  MMHelper.addControlHint(ev)
end)