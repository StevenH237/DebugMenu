local Settings = require "necro.config.Settings"
local SettingsStorage = require "necro.config.SettingsStorage"

Settings.user.number {
  name = "Nearby entity radius",
  desc = "In debugging nearby entities, how close is 'nearby'?",
  id = "nearbyRadius",
  order = 0,
  default = 2,
  minimum = 0,
  step = 0.5,
  editAsString = true,
  autoRegister = true
}

return {
  get = function(node) return SettingsStorage.get("mod.DebugMenu." .. node) end
}
