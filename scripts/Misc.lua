local Entities = require "system.game.Entities"
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
  end
}
