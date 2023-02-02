local Controls   = require "necro.config.Controls"
local Entities   = require "system.game.Entities"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextFormat = require "necro.config.i18n.TextFormat"
local UI         = require "necro.render.UI"
local Utilities  = require "system.utils.Utilities"

local NixLib = require "NixLib.NixLib"

local MMHelper = require "MenuMod.Helper"

local Text = require "DebugMenu.i18n.Text"

local function openComponentList(ent, lbl)
  -- Check to see whether component list setting is enabled
  if (false) then
    -- nothing
  else
    Menu.open("DebugMenu_entityViewer", { entity = ent, label = lbl })
  end
end

Event.menu.add("menuEntityPrototypeList", "DebugMenu_entityPrototypeList", function(ev)
  --[[ev.arg format:
  {
    entities = nil or {} -- list of names,
    hideSearch = true or nil
  }
  ]]

  -- Get the full list of entities
  local menu = {}
  local entries = {}
  local entities = {}

  local search = ev.searchText or ""

  if not ev.arg.hideSearch then
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
  end

  entries[#entries + 1] = {
    id = "_controlHint",
    label = string.format("%s: View entity components | %s: Print entity to log",
      Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT), Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT_2)),
    font = UI.Font.SMALL
  }

  if ev.arg.entities then
    entities = Utilities.map(ev.arg.entities, function(T)
      if Entities.isValidEntityType(T) then
        return Entities.getEntityPrototype(T)
      end
    end)
  else
    for i, e in Entities.prototypesWithComponents({}) do
      entities[#entities + 1] = e
    end
  end

  NixLib.sortBy(entities, "name", function(l, r)
    local l_ = l:find("_") ~= nil
    local r_ = r:find("_") ~= nil

    if l_ == r_ then
      return l < r
    elseif l_ then
      return false
    elseif r_ then
      return true
    end
  end)

  for i, v in ipairs(entities) do
    local name = v.name

    local label = name

    if name:lower():find(search:lower(), 1, true) then
      entries[#entries + 1] = {
        id = "entity_" .. v.id,
        label = label,
        action = function() openComponentList(v, label) end,
        specialAction = function() log.info(v) end
      }
    end
  end

  if not entries[#entries].DebugMenu_noDupe then
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
  menu.label = Text.Menu.EntityPrototypeList.Title
  menu.escapeAction = Menu.close
  menu.searchable = true
  ev.menu = menu
end)
