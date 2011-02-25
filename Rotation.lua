
local IFrameFactory = IFrameFactory("1.0")

Rotation = CreateFrame("Frame", "Rotation", UIParent)
IFrameManager:Register(Rotation, IFrameManager:Interface())


-- Height is always the same, width is a reasonable initial value
Rotation:SetWidth(200)
Rotation:SetHeight(44 + 6 + 26)
Rotation:SetPoint("CENTER", UIParent, "CENTER")


-- The cooldown bar, anchored at the top of the rotation indicator frame
Rotation.Bar = IFrameFactory:Create("Rotation", "Bar")
Rotation.Bar:SetPoint("TOPLEFT", Rotation)
Rotation.Bar:SetPoint("TOPRIGHT", Rotation)


-- Reloading the configuration basically means loading the config file,
-- and creating the appropriate action frames.
Rotation.Actions = { }
local function reloadConfiguration()
  -- Detect class and talent specialization and load its config
  local unitClass = select(2, UnitClass("player"))
  local activeConfig = RotationConfig[unitClass][GetActiveTalentGroup(false, false) + 1]

  -- Adjust the width of the Rotation frame
  Rotation:SetWidth(#activeConfig * 50)

  -- Clear all action icons
  IFrameFactory:Clear("Rotation", "Action")

  -- It's possible that the config file doesn't include the description for
  -- the current class or talent spec...
  if activeConfig == nil then return end

  -- Load each action into one frame
  Rotation.Actions = { }
  for _, action in pairs(activeConfig) do
    local frame = IFrameFactory:Create("Rotation", "Action")

    if (parent) then
      frame:SetPoint("LEFT", parent, "RIGHT", 12, 0)
    else
      frame:SetPoint("BOTTOMLEFT", Rotation, "BOTTOMLEFT", 6, 6)
    end

    frame:setAction(action)
    parent = frame

    -- Store the action in a table so we can later sort it and figure
    -- out the next best action
    table.insert(Rotation.Actions, frame)
  end
end


-- Reload configuration if the circumstances require
Rotation:RegisterEvent("PLAYER_LOGIN")
Rotation:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

-- Recalculate the action priorities on these events
Rotation:RegisterEvent("SPELL_UPDATE_COOLDOWN")
Rotation:RegisterEvent("SPELL_UPDATE_USABLE")
Rotation:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
Rotation:RegisterEvent("UNIT_AURA")


function print(s) ChatFrame1:AddMessage(s); end
Rotation:SetScript("OnEvent", function(self, event, ...)
print(event)
  if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
    reloadConfiguration()
  else
    Rotation:Update()
  end
end)

function Rotation:Update()
  print("Updating priorities")

  -- Sort by availability and priority
  table.sort(Rotation.Actions, function(a, b)
  if a == nil then return false; end
  if b == nil then return true; end
    if a:availableAt() == b:availableAt() then
      return a:getPriority() < b:getPriority()
    else
      return a:availableAt() < b:availableAt()
    end
  end)

  local hightlightMap = { "high", "medium" }
  for idx, action in ipairs(Rotation.Actions) do
    if hightlightMap[idx] then print("Highlighting "..action.config[1]); end
    action:doHighlight(hightlightMap[idx])
  end

  local action = Rotation.Actions[1]
  local timeLeft = action:availableAt() - GetTime()
  if (timeLeft > 0 and timeLeft < 1.5) then
    Rotation.Bar:showBar(action:availableAt() - 1.5, action:availableAt())
  end
end
