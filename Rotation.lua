
local IFrameFactory = IFrameFactory("1.0")

local Rotation = CreateFrame("Frame", "Rotation Indicator", UIParent)
IFrameManager:Register(Rotation, IFrameManager:Interface())

Rotation:SetWidth(200)
Rotation:SetHeight(38 + 4 + 26)
Rotation:SetPoint("CENTER", UIParent, "CENTER")


-- The cooldown bar, anchored at the top of the rotation indicator frame
Rotation.Bar = IFrameFactory:Create("Rotation", "Bar")
Rotation.Bar:SetPoint("TOPLEFT", Rotation)
Rotation.Bar:SetPoint("TOPRIGHT", Rotation)

local function reloadConfiguration()
  -- Detect class and talent specialization and load its config
  local unitClass = select(2, UnitClass("player"))
  local activeConfig = RotationConfig[unitClass][GetActiveTalentGroup(false, false)]

  -- Clear all action icons
  IFrameFactory:Clear("Rotation", "Action")

  -- It's possible that the config file doesn't include the description for
  -- the current class or talent spec...
  if activeConfig == nil then return end

  -- Load each spell into one action frame
  for _, action in pairs(activeConfig) do
    local frame = IFrameFactory:Create("Rotation", "Action")

    if (parent) then
      frame:SetPoint("LEFT", parent, "RIGHT", 4, 0)
    else
      frame:SetPoint("BOTTOMLEFT", Rotation, "BOTTOMLEFT", 2, 2)
    end

    frame:setAction(action)
    parent = frame
  end
end

-- Reload configuration if the circumstances require
Rotation:RegisterEvent("PLAYER_LOGIN")
Rotation:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

Rotation:SetScript("OnEvent", function(self, event, ...)
  reloadConfiguration()
end)


Rotation:SetScript("OnUpdate", function(self, elapsed)
  local now, start, duration = GetTime(), GetTime() + 999, 0
  for _, action in ipairs(self.Actions) do
    if (action.start + action.duration < (start + duration)) then
      start, duration = action.start, action.duration
    end
  end

  timeLeft = start + duration - now
  if (timeLeft > 0) then
    Rotation.Bar:showBar(start, start + duration)
  end
end)
