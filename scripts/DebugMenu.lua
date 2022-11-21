local CustomActions = require "necro.game.data.CustomActions"

local DMDebugging = require "DebugMenu.Debugging"
local Text        = require "DebugMenu.i18n.Text"

CustomActions.registerHotkey {
  id = "debugMenu",
  name = Text.Controls.Menu,
  keyBinding = { "Ctrl + M" },
  callback = DMDebugging.Menu
}
