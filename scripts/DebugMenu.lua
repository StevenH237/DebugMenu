local CustomActions = require "necro.game.data.CustomActions"

local DMDebugging = require "DebugMenu.Debugging"
local Text        = require "DebugMenu.i18n.Text"

local MenuMod = require "MenuMod.MenuMod"

MenuMod.register {
  name = Text.Menu.EntityPicker.Title,
  menu = "DebugMenu_entityPicker",
  id = "entityPicker",
  subsequence = 1,
  menuArg = {}
}
