local Text = require "DebugMenu.i18n.Text"

local MenuMod = require "MenuMod.MenuMod"

MenuMod.register {
  name = Text.Menu.EntityList.Title,
  menu = "DebugMenu_entityList",
  id = "entityList",
  subsequence = 1,
  menuArg = {}
}

MenuMod.register {
  name = Text.Menu.EntityPrototypeList.Title,
  menu = "DebugMenu_entityPrototypeList",
  id = "entityPrototypeList",
  subsequence = 2,
  menuArg = {}
}

MenuMod.register {
  name = Text.Menu.ComponentList.Title,
  menu = "DebugMenu_componentList",
  id = "componentList",
  subsequence = 3,
  menuArg = {}
}
