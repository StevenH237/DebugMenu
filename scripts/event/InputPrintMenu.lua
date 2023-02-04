local Event = require "necro.event.Event"
local Input = require "system.game.Input"
local Menu  = require "necro.menu.Menu"

Event.tick.add("printMenu", { order = "debugKeys" }, function(ev)
  if Input.keyPress("p") and (Input.keyDown("lcontrol") or Input.keyDown("rcontrol")) then
    if (Input.keyDown("lshift") or Input.keyDown("rshift")) then
      print(Menu.getPopup())
    else
      print(Menu.getNonPopup())
    end
  end

  if Input.keyPress("l") and (Input.keyDown("lcontrol") or Input.keyDown("rcontrol")) then
    print(Menu.getSelectedEntry().label())
  end
end)
