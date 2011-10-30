
RotationConfig = {
  ["WARRIOR"] = {
    ["single-damage"] = {
      { "s", "Recklessness",    [[ true ]] },
      { "s", "Death Wish",      [[ true ]] },
      { "s", "Cleave",          [[ enemies() > 1 ]] },
      { "s", "Whirlwind",       [[ enemies() > 1 ]] },
      { "s", "Heroic Strike",   [[ mana() >= 85 and targetHealthPercent() >= 20 ]] },
      { "s", "Execute",         [[ targetHealthPercent() <= 20 and buffRemains("Executioner Talent") <= 1.5 ]] },
      { "s", "Colossus Smash",  [[ true ]] },
      { "s", "Execute",         [[ targetHealthPercent() <= 20 and buffStacks("Executioner Talent") < 5 ]] },
      { "s", "Bloodthirst",     [[ true ]] },
      { "s", "Berserker Rage",  [[ cooldownRemaining("Raging Blow") > 1 ]] },
      { "s", "Raging Blow",     [[ hasBuff("Enrage") or hasBuff("Death Wish") or hasBuff("Berserker Rage") or hasBuff("Unholy Frenzy") ]] },
      { "s", "Slam",            [[ hasBuff("Bloodsurge") ]] },
      { "s", "Execute",         [[ mana() >= 50 ]] },
      { "s", "Battle Shout",    [[ mana() < 75 ]] },
    },
    ["multi-damage"] = {
    },
  },
  ["PRIEST"] = {
    ["single-damage"] = {
      { "s", "Shadow Word: Pain",   [[ true ]] },
      { "s", "Mind Blast",          [[ buffStacks("Shadow Orb") > 0 ]] },
      { "s", "Vampiric Touch",      [[ true ]] },
      { "s", "Devouring Plague",    [[ true ]] },
      { "s", "Mind Blast",          [[ buffStacks("Shadow Orb") == 0 ]] },
      { "s", "Shadow Word: Death",  [[ true ]] },
      { "s", "Archangle",           [[ true ]] },
      { "s", "Shadowfiend",         [[ true ]] },
      { "s", "Mind Flay",           [[ true ]] },
    },
    ["multi-damage"] = {
    },
  },
}

