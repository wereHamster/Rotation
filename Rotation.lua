
-- Bindings headers and labels
BINDING_HEADER_ROTATION = "Rotation"
BINDING_NAME_ROTATION_CHANGE_PRESET = "Change rotation preset"


local IFrameFactory = IFrameFactory("1.0")

Rotation = IFrameFactory:Create("Rotation", "Rotation")
IFrameManager:Register(Rotation, IFrameManager:Interface())

-- Just for debugging purposes
local function log(msg)
  ChatFrame1:AddMessage(msg)
end

-- Default is the single target damage preset. You can change it with
-- the keybindings.
local presetList, activePreset = { "single-damage", "multi-damage", "single-threat", "multi-threat" }, 1

-- Reloading the configuration basically means loading the config file,
-- and creating the appropriate action frames.
local Actions = { Frames = { }, List = { } }
local function reloadConfiguration()
  -- Clear all action frames
  IFrameFactory:Clear("Rotation", "Action")

  -- Detect class and talent specialization and load its config
  local unitClass = select(2, UnitClass("player"))
  local classConfig = RotationConfig[unitClass]
  if classConfig == nil then return end

  local preset = presetList[activePreset]
  local activeConfig = classConfig[preset]

  -- Set the correct icons
  local icon1, icon2 = ("-"):split(preset)
  Rotation.setPreset(icon1, icon2)

  -- It's possible that the config file doesn't include the description for
  -- the current class or talent spec...
  if activeConfig == nil then return end


  -- Load each action into one frame
  Actions = { Frames = { }, List = { } }

  local parent, num = nil, 0
  for _, entry in pairs(activeConfig) do
    local type, name, fn = unpack(entry)

    local frame = Actions.Frames[name]
    if not frame then
      frame = IFrameFactory:Create("Rotation", "Action")

      -- Store the frame to keep track of which frames we've already created.
      Actions.Frames[name] = frame
      frame:setAction(entry)

      frame.prio = num
      parent, num = frame, num + 1
    end

    table.insert(Actions.List, frame)
  end
end

-- This is bound to a key
Rotation.changePreset = function()
  activePreset = ((activePreset) % (#presetList)) + 1
  reloadConfiguration(); Rotation:Update()
end

-- Reload configuration if the circumstances require
Rotation:RegisterEvent("PLAYER_LOGIN")
Rotation:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

-- Recalculate the action priorities on these events
Rotation:RegisterEvent("SPELL_UPDATE_COOLDOWN")
Rotation:RegisterEvent("SPELL_UPDATE_USABLE")
Rotation:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
Rotation:RegisterEvent("UNIT_AURA")


Rotation:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
    reloadConfiguration()
  end

  Rotation:Update()
end)


local function sortByPriority(a, b)
  if a == nil then return false; end
  if b == nil then return true; end

  if a:availableAt() == b:availableAt() then
    return a.prio < b.prio
  else
    return a:availableAt() < b:availableAt()
  end
end

-- Everyone can call this function if the action priorities may have changed.
-- One user are the action frames themselves, as there is no event fired when
-- a cooldown expires.
function Rotation:Update()
  table.sort(Actions.List, sortByPriority)
  local actionInRotation = {}
  local highlightMap, idx, nextAction = { "high", "medium" }, 1, nil
  for _, action in ipairs(Actions.List) do

    if idx < 4 and action:canExecute() then
      if not actionInRotation[action.config[2]] then
        Rotation.setAction(idx, action)
        idx = idx + 1
        nextAction = nextAction or action
        actionInRotation[action.config[2]] = 1
      end
    else
      action:ClearAllPoints()
      action:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", 0, 0)
    end
  end

  if #Actions.List == 0 then return end

  -- The bar shows the last 1.5 seconds of the cooldown to the next action
  nextAction = nextAction or Actions.List[1]
  local timeLeft = nextAction:availableAt() - GetTime()
  if timeLeft > 0 then
    Rotation.Bar:showBar(nextAction:availableAt() - 1.5, nextAction:availableAt())
  end
end
