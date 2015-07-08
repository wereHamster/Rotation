
-- The methods you specify in the config file will be executed inside
-- the following environment.

RotationConfigEnvironment = {
  ["mana"] = function()
    return UnitMana("player")
  end,
  ["enemies"] = function()
    return 0
  end,
  ["buffRemains"] = function()
    return 0
  end,
  ["buffStacks"] = function(name)
    local n, r, i, count = UnitBuff("player", name)
    if count == nil then return 0 else return count end
  end,
  ["hasBuff"] = function(name)
    return UnitBuff("player", name)
  end,
  ["targetHealthPercent"] = function()
    return UnitHealth("target") / UnitHealthMax("target") * 100
  end,
  ["cooldownRemaining"] = function(name)
    local s, d = GetSpellCooldown(name)
    if s == nil or d == 0 then
      return 0
    else
      return (s + d - GetTime())
    end
  end,
  ["targetHasDot"] = function(name)
    return UnitDebuff("target", name)
  end,
}
