local Controls   = require "necro.config.Controls"
local Event      = require "necro.event.Event"
local Menu       = require "necro.menu.Menu"
local TextFormat = require "necro.config.i18n.TextFormat"
local UI         = require "necro.render.UI"
local Utilities  = require "system.utils.Utilities"

local Text = require "DebugMenu.i18n.Text"

local NixLib = require "NixLib.NixLib"
local NLText = require "NixLib.i18n.Text"

Event.menu.add("menuSearchEC", "DebugMenu_searchEntityComponents", function(ev)
  --[[
    ev.arg format:
    {
      required = {
        componentName = true
      },
      excluded = {
        componentName = true
      }
    }
  ]]

  local menu = {}
  local entries = {
    {
      id = "_controlHint",
      label = string.format("%s: Toggle required (" ..
        TextFormat.Symbol.SMALL_CHECKBOX_ON ..
        ") | %s: Toggle excluded (" .. Text.Icon.CheckboxNoSmall .. ") | %s/%s: Cycle state",
        Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT), Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT_2),
        Controls.getFriendlyMiscKeyBind(Controls.Misc.MENU_LEFT),
        Controls.getFriendlyMiscKeyBind(Controls.Misc.MENU_RIGHT)),
      font = UI.Font.SMALL
    }
  }

  for k, v in Utilities.sortedPairs(NixLib.getComponents()) do
    table.insert(entries, {
      id = "component_" .. v.name,
      label = function()
        if ev.arg.required[v.name] then
          return TextFormat.Symbol.CHECKBOX_ON .. " " .. v.name
        elseif ev.arg.excluded[v.name] then
          return Text.Icon.CheckboxNo .. " " .. v.name
        else
          return TextFormat.Symbol.CHECKBOX_OFF .. " " .. v.name
        end
      end,
      action = function()
        if ev.arg.required[v.name] then
          ev.arg.required[v.name] = nil
        else
          ev.arg.required[v.name] = true
          ev.arg.excluded[v.name] = nil
        end
      end,
      specialAction = function()
        if ev.arg.excluded[v.name] then
          ev.arg.excluded[v.name] = nil
        else
          ev.arg.excluded[v.name] = true
          ev.arg.required[v.name] = nil
        end
      end,
      leftAction = function()
        if ev.arg.required[v.name] then
          ev.arg.required[v.name] = nil
        elseif ev.arg.excluded[v.name] then
          ev.arg.excluded[v.name] = nil
          ev.arg.required[v.name] = true
        else
          ev.arg.excluded[v.name] = true
        end
      end,
      rightAction = function()
        if ev.arg.required[v.name] then
          ev.arg.required[v.name] = nil
          ev.arg.excluded[v.name] = true
        elseif ev.arg.excluded[v.name] then
          ev.arg.excluded[v.name] = nil
        else
          ev.arg.required[v.name] = true
        end
      end,
      actionHint = "Toggle required",
      specialActionHint = "Toggle excluded",
      sideActionHint = "Cycle state"
    })
  end

  table.insert(entries, {
    height = 0
  })

  local function closeCallback()
    Menu.close()
    ev.arg.callback()
  end

  table.insert(entries, {
    id = "_close",
    action = closeCallback,
    label = NLText.Close
  })

  menu.entries = entries
  menu.label = Text.Menu.SearchEntityComponents.Title
  menu.escapeAction = closeCallback
  menu.searchable = true

  ev.menu = menu
end)
