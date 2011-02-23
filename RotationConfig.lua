
RotationConfig = {
  ["WARRIOR"] = {
    [1] = {
      { "Bloodthirst", [[
          1
        ]]
      },
      { "Raging Blow", [[
          1
        ]]
      },
      { "Heroic Strike", [[
          return mana() > 85 and 0 or 100
        ]]
      },
    }
  },
  ["MAGE"] = {
    [1] = {
      { "Frostbolt", },
      { "Ice Lance", },
      { "Frost Nova", },
      { "Cone of Cold", },
      { "Ice Lance", },
      { "Fireball", },
    }
  },
}
