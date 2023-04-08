local Entities  = require "system.game.Entities"
local Event     = require "necro.event.Event"
local Menu      = require "necro.menu.Menu"
local Try       = require "system.utils.Try"
local Utilities = require "system.utils.Utilities"

local DMEntComponents = require "DebugMenu.data.EntityComponents"

local MMHelper = require "MenuMod.Helper"

local NixLib = require "NixLib.NixLib"
local NLText = require "NixLib.i18n.Text"

local Text = require "DebugMenu.i18n.Text"

local function selectField(i, arg)
  arg.fieldSelected = i

  local name = arg.fieldList[i]
  arg.fieldName = name

  local fld = arg.component.fields[i]
  arg.fieldData = fld

  Menu.update()
end

local function selectPriorField(arg)
  local now = arg.fieldSelected - 1
  if now == 0 then
    now = #(arg.fieldList)
  end

  selectField(now, arg)
end

local function selectNextField(arg)
  local now = arg.fieldSelected + 1
  if now == #(arg.fieldList) + 1 then
    now = 1
  end

  selectField(now, arg)
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

  -- Did the component change? We'll need to regen the field lists if so.
  if ev.arg.fieldList == nil then
    local ent = ev.arg.entity

    ev.arg.fieldData = {}
    ev.arg.fieldList = {}
    ev.arg.fieldName = ""
    ev.arg.fieldSelected = 0

    ev.arg.fieldList = Utilities.map(ev.arg.component.fields, function(d) return d.name end)

    selectField(1, ev.arg)
  end

  local menu = {}
  local entries = {
    {
      id = "componentLabel",
      label = ev.arg.component.name
    },
    {
      id = "fieldPicker",
      label = ev.arg.fieldName,
      action = function() end,
      leftAction = function() selectPriorField(ev.arg) end,
      rightAction = function() selectNextField(ev.arg) end,
    },
    {
      height = 0
    }
  }

  local fieldSpec = ev.arg.fieldData

  -- Check for a type first
  local typ = fieldSpec.type

  if typ == "int" and fieldSpec.enum then
    typ = Text.Menu.ComponentViewer.Types.Enum
  end

  entries[4] = {
    id = "fieldType",
    label = Text.Menu.ComponentViewer.Type(typ),
    action = function() end
  }

  -- Next is the default value
  -- This is skipped for entityID types because they can't have a meaningful default.
  if typ ~= "entityID" then
    local enum = fieldSpec.enum
    local value = fieldSpec.default
    if enum then
      if not pcall(function() value = enum.inspect(value) end) then
        value = enum.names[value]
      end
    end

    entries[5] = {
      id = "fieldDefault",
      label = Text.Menu.ComponentViewer.Default(Utilities.inspect(value)),
      action = function() end
    }

    if typ == "string" or typ == "table" then
      entries[5].specialAction = function() log.info(Utilities.inspect(value)) end
    end

    if enum then
      entries[6] = {
        id = "fieldEnum",
        label = Text.Menu.ComponentViewer.ShowEnum,
        action = function()
          Menu.open("DebugMenu_tableViewer", {
            prefix = ev.arg.component.name .. "." .. ev.arg.fieldName,
            table = enum
          })
        end
      }
    end
  end

  -- Check for a mutable field third
  local mut = NLText.Yes
  if fieldSpec.mutability == "constant" then
    mut = NLText.No
  end

  entries[#entries + 1] = {
    id = "fieldMutability",
    label = Text.Menu.ComponentViewer.Mutability(mut),
    action = function() end
  }

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
  menu.label = Text.Menu.ComponentViewer.Title
  menu.escapeAction = Menu.close
  ev.menu = menu

  MMHelper.addControlHint(ev)
end)
