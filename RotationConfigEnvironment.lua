
-- The methods you specify in the config file will be executed inside
-- the following environment.

RotationConfigEnvironment = {
  ["mana"] = function()
    return UnitMana("player")
  end
}
