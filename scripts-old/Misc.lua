local Controls = require "necro.config.Controls"
local Entities = require "system.game.Entities"
local Map      = require "necro.game.object.Map"
local Menu     = require "necro.menu.Menu"
local UI       = require "necro.render.UI"

local NixLib = require "NixLib.NixLib"

local Text = require "DebugMenu.i18n.Text"

return {
  labelEntity = function(ent, id)
    if not ent then
      return Text.Menu.EntityPicker.Label.NonExistent(id)
    elseif ent.item and ent.item.equipped then
      local holder = Entities.getEntityByID(ent.item.holder)
      return Text.Menu.EntityPicker.Label.Inventory(ent.name, ent.id, holder.name, holder.id)
    elseif ent.position then
      return Text.Menu.EntityPicker.Label.WithPosition(ent.name, ent.id, ent.position.x, ent.position.y)
    else
      return Text.Menu.EntityPicker.Label.Default(ent.name, ent.id)
    end
  end,

  getNearbyEntities = function(ourX, ourY, r)
    local r2 = r * r
    local fr = math.floor(r)

    local out = {}

    for dx = -fr, fr do
      local sr = math.sqrt(r2 - dx * dx)
      local fsr = math.floor(sr)
      local x = ourX + dx
      for dy = -fsr, fsr do
        local y = ourY + dy
        local ents = Map.getAll(x, y)
        for i, v in ipairs(ents) do
          out[#out + 1] = v
        end
      end
    end

    return out
  end,

  addControlHint = function(ev)
    ev.menu.tickCallback = function()
      local arg = ev.arg

      local id = Menu.getSelectedID()
      if arg.selected == id then return end

      arg.selected = id
      local entry = Menu.getSelectedEntry()

      -- Construct the controls entry
      local controls = {}
      if entry.sideActionHint then
        table.insert(controls, ("%s/%s: %s"):format(
          Controls.getFriendlyMiscKeyBind(Controls.Misc.MENU_LEFT),
          Controls.getFriendlyMiscKeyBind(Controls.Misc.MENU_RIGHT),
          entry.sideActionHint
        ))
      end

      if entry.actionHint then
        table.insert(controls, ("%s: %s"):format(
          Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT),
          entry.actionHint
        ))
      end

      if entry.specialActionHint then
        table.insert(controls, ("%s: %s"):format(
          Controls.getFriendlyMiscKeyBind(Controls.Misc.SELECT_2),
          entry.specialActionHint
        ))
      end

      if ev.menu.searchHint then
        table.insert(controls, ("%s: %s"):format(
          Controls.getFriendlyMiscKeyBind(Controls.Misc.SEARCH),
          ev.menu.searchHint
        ))
      end

      arg.controls = NixLib.join(controls, " | ")
      if arg.controls == "" then arg.controls = nil end

      Menu.update()
    end

    if ev.arg.controls then
      ev.menu.footerSize = 40

      ev.menu.entries[#ev.menu.entries + 1] = {
        id = "_controls",
        label = ev.arg.controls,
        sticky = 1, y = -14,
        font = UI.Font.SMALL
      }
    end
  end
}
