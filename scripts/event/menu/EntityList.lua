local Entities   = require "system.game.Entities"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextFormat = require "necro.config.i18n.TextFormat"
local Utilities  = require "system.utils.Utilities"

local MMHelper = require "MenuMod.Helper"

local Text = require "DebugMenu.i18n.Text"

local function getEntityLabel(ent)
  if ent.item and ent.item.equipped then
    local holder = Entities.getEntityByID(ent.item.holder)
    return TextFormat.fade(
      Text.Menu.EntityList.Label.Inventory(
        TextFormat.fade(ent.name .. "#" .. ent.id, 1),
        holder.name, holder.id),
      0.75)
  elseif ent.position then
    return TextFormat.fade(
      Text.Menu.EntityList.Label.WithPosition(
        TextFormat.fade(ent.name .. "#" .. ent.id, 1),
        ent.position.x, ent.position.y),
      0.6)
  else
    return ent.name .. "#" .. ent.id
  end
end

local function openComponentList(ent, lbl)
  -- Check to see whether component list setting is enabled
  if (false) then
    -- nothing
  else
    Menu.open("DebugMenu_entityViewer", { entity = ent, label = lbl })
  end
end

Event.menu.add("menuEntityList", "DebugMenu_entityList", function(ev)
  --[[ev.arg format:
  {
    entities = nil or {} -- list of IDs,
    controls = nil or "string",
    selected = nil or "string"
  }
  ]]

  -- Get the full list of entities
  local menu = {}
  local entries = {}
  local entities = {}

  local search = ev.searchText or ""

  entries[1] = {
    id = "_advSearch",
    label = Text.Menu.SearchEntities.Title,
    action = function() Menu.open("DebugMenu_searchEntities") end,
    searchImmunity = true
  }

  entries[2] = {
    height = 0,
    searchImmunity = true
  }

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

  for i, v in ipairs(entities) do
    local name = v.name .. "#" .. v.id

    local label = getEntityLabel(v)

    if name:lower():find(search:lower(), 1, true) then
      entries[#entries + 1] = {
        id = "entity_" .. v.id,
        label = label,
        action = function() openComponentList(v, label) end,
        actionHint = "View entity components",
        specialAction = function() print(v) end,
        specialActionHint = "Print to log"
      }
    end
  end

  if #entries > 2 then
    entries[#entries + 1] = {
      height = 0,
      searchImmunity = true
    }
  end

  entries[#entries + 1] = {
    id = "_done",
    label = Text.Menu.Close,
    action = Menu.close,
    searchImmunity = true
  }

  menu.entries = entries
  menu.label = Text.Menu.EntityList.Title
  menu.escapeAction = Menu.close
  menu.searchable = true
  ev.menu = menu

  MMHelper.addControlHint(ev)
end)
