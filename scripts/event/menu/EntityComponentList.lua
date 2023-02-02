local Controls   = require "necro.config.Controls"
local Entities   = require "system.game.Entities"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextFormat = require "necro.config.i18n.TextFormat"
local Try        = require "system.utils.Try"
local UI         = require "necro.render.UI"
local Utilities  = require "system.utils.Utilities"

local MMHelper = require "MenuMod.Helper"

local NixLib = require "NixLib.NixLib"
local NLText = require "NixLib.i18n.Text"

local DMEntComponents = require "DebugMenu.data.EntityComponents"
local Text            = require "DebugMenu.i18n.Text"

Event.menu.add("menuEntityComponentList", "DebugMenu_entityComponentList", function(ev)
  --[[ev.arg format:
  {
    entity = { -- Entity#237 },
    componentList = {"name"},
    callback = function(name) end
  }
  ]]

  local menu = {}
  local entries = {}

  for i, v in ipairs(ev.arg.componentList) do
    table.insert(entries, {
      id = "component_" .. v,
      label = v,
      action = function()
        Menu.close()
        ev.arg.callback(v, i)
      end
    })
  end

  table.insert(entries, { height = 0 })
  table.insert(entries, {
    id = "_close",
    label = NLText.Close,
    action = Menu.close
  })

  menu.entries = entries
  menu.label = Text.Menu.EntityComponentList.Title
  menu.escapeAction = Menu.close
  menu.searchable = true
  ev.menu = menu
end)
