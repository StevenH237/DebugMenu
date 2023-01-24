local Text = require "DebugMenu.i18n.Text"

local MenuMod = require "MenuMod.MenuMod"

MenuMod.register {
  name = Text.Menu.EntityList.Title,
  menu = "DebugMenu_entityList",
  id = "entityList",
  subsequence = 1,
  menuArg = {}
}
