local StringUtilities = require "system.utils.StringUtilities"

local NixLib = require "NixLib.NixLib"

local data = {
  Sync = {
    npcTrader = {
      soldItems = "set"
    },
    targetLockHostileProvider = {
      provokers = true
    },
    weaponLastTargets = {
      targets = "set"
    }
  },
  _ = {
    editorLinkParentEntity = {
      children = true
    },
    electrifyGround = {
      patterns = false -- FALSE ON PURPOSE
      -- This is a known not-entity table that could look like one
    },
    equipment = {
      items = true
    },
    inventory = {
      items = true,
      itemSlots = true
    },
    multiHitProtection = {
      attackers = true
    },
    secretFightMarker = {
      enemies = true
    },
    shoplifter = {
      stolenShopkeepers = true
    },
    soulLeader = {
      souls = true
    },
    soulLinkInventory = {
      slots = true
    },
    storage = {
      items = true
    }
  }
}

local function containsOnlyPositiveInts(tbl)
  for k, v in pairs(tbl) do
    if type(v) == "table" and not containsOnlyPositiveInts(v) then
      return false
    elseif type(v) ~= "number" then
      return false
    elseif v ~= math.floor(v) or v <= 0 then
      return false
    end
  end
  return true
end

return {
  isEntityTable = function(cmp, tbl)
    local mod, comp, field = unpack(StringUtilities.split(cmp, "_"))

    if not comp then
      comp, mod = mod, "_"
    end

    comp, field = unpack(StringUtilities.split(comp, "%."))

    if data[mod] then
      if data[mod][comp] and data[mod][comp][field] ~= nil then
        return data[mod][comp][field]
      else
        return nil
      end
    end

    -- Can we get the info from the calling mod?
    local state, result = pcall(require, mod .. ".DebugMenu.data.EntityComponents")

    if state then
      return result.isEntityTable(cmp)
    end

    -- Guess we'll have to speculate the info.
    -- We'll consider it "speculatively true" if, at the time of opening, the following is true about the table:
    -- 1. It's in a non-constant field (entity IDs can never be specified in constants)
    -- 2. All values are positive integers, or sub-tables containing such
    -- We'll signal a "speculatively true" with a nil return value.
    local cData
    if mod == "_" then
      cData = NixLib.getComponent(comp)
    else
      cData = NixLib.getComponent(mod .. "_" .. comp)
    end

    local fData
    for i, v in ipairs(cData.fields) do
      if v.name == field then
        fData = v
        break
      end
    end

    if fData == nil then return nil end
    if fData.mutability == "constant" then return false end

    -- It's passed condition 1, now check condition 2
    if containsOnlyPositiveInts(tbl) then
      return nil
    else
      return false
    end
  end
}
