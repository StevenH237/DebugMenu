local Entities = require "system.game.Entities"
local Map      = require "necro.game.object.Map"
local Text     = require "DebugMenu.i18n.Text"

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
  end
}
