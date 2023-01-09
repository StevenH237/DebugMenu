local Entities        = require "system.game.Entities"
local Map             = require "necro.game.object.Map"
local Menu            = require "necro.menu.Menu"
local Player          = require "necro.game.character.Player"
local PlayerList      = require "necro.client.PlayerList"
local SettingsStorage = require "necro.config.SettingsStorage"
local StateControl    = require "necro.client.StateControl"

local DMPauseEvent = require "DebugMenu.event.Pause"
local DMSettings   = require "DebugMenu.Settings"

local module = {}

function module.Nearby()
  -- First let's find us.
  local player = Player.getPlayerEntity(PlayerList.getLocalPlayerID())
  local ourX = player.position.x
  local ourY = player.position.y

  local r = DMSettings.get("nearbyRadius")
  local r2 = r * r
  local fr = math.floor(r)

  for dx = -fr, fr do
    local sr = math.sqrt(r2 - dx * dx)
    local fsr = math.floor(sr)
    local x = ourX + dx
    for dy = -fsr, fsr do
      local y = ourY + dy
      local ents = Map.getAll(x, y)
      for i, v in ipairs(ents) do
        print(v)
      end
    end
  end
end

function module.Menu()
  if StateControl.isPauseAllowed() then
    StateControl.pauseWithoutMenu()
  end

  Menu.open("DebugMenu_debugMenu", {
    wasPaused = DMPauseEvent.isPaused()
  })
end

return module
