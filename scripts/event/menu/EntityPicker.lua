local Entities   = require "system.game.Entities"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local Player     = require "necro.game.character.Player"
local PlayerList = require "necro.client.PlayerList"

local DMMisc     = require "DebugMenu.Misc"
local DMSettings = require "DebugMenu.Settings"

local Text = require "DebugMenu.i18n.Text"

local function getHighestEntity()
  local id = 0
  for ent in Entities.entitiesWithComponents({}) do
    if ent.id > id then
      id = ent.id
    end
  end
  return id
end

local function selectEntity(inp, arg)
  local ent
  local id
  if type(inp) == "number" then
    id = inp
    if Entities.entityExists(inp) then
      ent = Entities.getEntityByID(inp)
      arg.entityID = inp
      arg.entity = ent
    else
      ent = nil
      arg.entityID = inp
      arg.entity = nil
    end
  elseif type(inp) == "table" or type(inp) == "userdata" then
    ent = inp
    id = ent.id
    arg.entityID = ent.id
    arg.entity = ent
  end

  -- Get the label
  arg.entityLabel = DMMisc.labelEntity(ent, id)

  -- Refresh the menu
  Menu.update()
end

local function selectLowerEntity(arg)
  local id = arg.entityID

  repeat
    id = id - 1
    if id == 0 then
      id = getHighestEntity()
    end
  until Entities.entityExists(id) or id == arg.entityID

  selectEntity(id, arg)
end

local function selectHigherEntity(arg)
  local id = arg.entityID
  local high = getHighestEntity()

  repeat
    id = id + 1
    if id > high then
      id = 1
    end
  until Entities.entityExists(id) or id == arg.entityID

  selectEntity(id, arg)
end

Event.menu.add("menuPickEntity", "DebugMenu_entityPicker", function(ev)
  --[[ev.arg format:
  {
    entity = {},
    entityID = 0,
    entityLabel = ""
  }
  ]]

  local high = getHighestEntity()

  if high == 0 then
    Menu.close()
  end

  if ev.arg.entityLabel == nil then
    selectEntity(ev.arg.entity or ev.arg.entityID or Player.getPlayerEntity(PlayerList.getLocalPlayerID()) or high,
      ev.arg)
  end

  local menu = {}
  local entries = {
    {
      id = "selectEntity",
      label = function()
        return Text.Menu.EntityPicker.Select(ev.arg.entityID)
      end,
      leftAction = function() selectLowerEntity(ev.arg) end,
      rightAction = function() selectHigherEntity(ev.arg) end,
      action = function()
        Menu.open("DebugMenu_entityList", {
          callback = function(pick)
            Menu.close()
            selectEntity(pick, ev.arg)
          end --, entities = nil
        })
      end,
      specialAction = function()
        selectEntity(Player.getPlayerEntity(PlayerList.getLocalPlayerID()) or getHighestEntity, ev.arg)
      end
    },
    {
      id = "entityLabel",
      label = function()
        return "(" .. ev.arg.entityLabel .. ")"
      end
    }
  }

  if ev.arg.entity then
    local ent = ev.arg.entity

    entries[3] = {
      id = "viewEntity",
      label = Text.Menu.EntityPicker.ViewEntity,
      action = function()
        Menu.open("DebugMenu_entityViewer", {
          entity = ent,
          label = ev.arg.entityLabel
        })
      end,
      specialAction = function()
        print(ent)
      end
    }

    if ent.gameObject and ent.gameObject.tangible then
      entries[4] = {
        id = "nearbyEntity",
        label = Text.Menu.EntityPicker.Nearby,
        action = function()
          Menu.open("DebugMenu_entityList", {
            callback = function(pick)
              Menu.close()
              selectEntity(pick, ev.arg)
            end,
            entities = DMMisc.getNearbyEntities(ent.position.x, ent.position.y, DMSettings.get("nearbyRadius"))
          })
        end
      }
    end
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
  menu.label = Text.Menu.EntityPicker.Title
  menu.escapeAction = Menu.close
  ev.menu = menu
end)
