local Entities   = require "system.game.Entities"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextPrompt = require "necro.render.ui.TextPrompt"

local Text = require "DebugMenu.i18n.Text"

local MMHelper = require "MenuMod.Helper"

local function searchEntities(params)
  local results = {}

  for e in Entities.entitiesWithComponents(params.withComponents) do
    if params.name ~= "" and not e.name:find(params.name) then
      goto continue
    end

    for i, v in ipairs(params.withoutComponents) do
      if e[v] then goto continue end
    end

    table.insert(results, e.id)

    ::continue::
  end

  Menu.open("DebugMenu_entityList", {
    entities = results,
    hideSearch = true
  })
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
  entName.specialAction = function() ev.arg.name = "" end
  entName.specialActionHint = "Reset"

  local menu = {}
  local entries = {
    entName,
    {
      id = "components",
      label = function() return Text.Menu.SearchEntities.Components(#ev.arg.withComponents, #ev.arg.withoutComponents) end,
      action = function()
        local excluded = {}
        for i, v in ipairs(ev.arg.withoutComponents) do
          excluded[v] = true
        end

        local required = {}
        for i, v in ipairs(ev.arg.withComponents) do
          required[v] = true
        end

        Menu.open("DebugMenu_searchEntityComponents", {
          excluded = excluded,
          required = required,
          callback = function()
            ev.arg.withoutComponents = {}
            for k, v in pairs(excluded) do
              table.insert(ev.arg.withoutComponents, k)
            end

            ev.arg.withComponents = {}
            for k, v in pairs(required) do
              table.insert(ev.arg.withComponents, k)
            end
          end
        })
      end,
      actionHint = "Select components to require/exclude",
      specialAction = function()
        ev.arg.withoutComponents = {}
        ev.arg.withComponents = {}
      end,
      specialActionHint = "Reset"
    },
    {
      height = 0
    },
    {
      id = "_search",
      label = Text.Menu.SearchEntities.Search,
      action = function() searchEntities(ev.arg) end
    },
    {
      id = "_close",
      label = Text.Menu.Close,
      action = Menu.close
    }
  }

  menu.entries = entries
  menu.label = Text.Menu.SearchEntities.Title
  menu.escapeAction = Menu.close
  ev.menu = menu

  MMHelper.addControlHint(ev)
end)
