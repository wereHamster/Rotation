
local FactoryInterface = { }
IFrameFactory("1.0"):Register("Rotation", "Action", FactoryInterface)

local function findSpellByName(name)
  local bookTypes = { BOOKTYPE_SPELL, BOOKTYPE_PET }
  for _, type in ipairs(bookTypes) do
    local spellID = 1
    local spell = GetSpellBookItemName(spellID, type)

    while (spell) do
      if (spell == name) then
        return type, spellID
      end

      spellID = spellID + 1
      spell = GetSpellBookItemName(spellID, type)
    end
  end
end

local function reloadConfiguration(self)
end

local function setAction(self, config)
  self.config = config

  -- Store the spell book type and ID
  self.spellBookType, self.spellID = findSpellByName(config[1])
  local tex = GetSpellTexture(self.spellID, self.spellBookType)
  self.texture:SetTexture(tex)

  -- Load the priority function
  local functionString = "return function() return "..self.config[2].."; end"
  self.calculatePriority = loadstring(functionString)

  -- Restrict the execution environment to our special one
  setfenv(self.calculatePriority, RotationConfigEnvironment)

  self.start, self.duration = 0, 0

  reloadConfiguration()
end

local function onEvent(self, event, ...)
  
end

local function onUpdate(self, elapsed)
  local start, duration, hasCooldown = GetSpellCooldown(self.spellID, self.spellBookType)
  self.hasCooldown, self.start, self.duration = hasCooldown, start, duration
end

function FactoryInterface:Create()
  local frame = CreateFrame("Frame", nil, UIParent)

  frame:SetWidth(38)
  frame:SetHeight(38)

  frame.texture = frame:CreateTexture(nil, "ARTWORK")
  frame.texture:SetWidth(34)
  frame.texture:SetHeight(34)
  frame.texture:SetPoint("CENTER", frame, "CENTER", 0, 0)

  frame.border = frame:CreateTexture(nil, "OVERLAY")
  frame.border:SetWidth(38)
  frame.border:SetHeight(38)
  frame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Border")
  frame.border:SetPoint("CENTER", frame, "CENTER", 0, 0)
  frame.border:SetVertexColor(0, 0, 0, 1)

  frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
  frame:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
  frame:RegisterEvent("UNIT_AURA")

  frame:SetScript("OnEvent", onUpdate)
  frame:SetScript("OnUpdate", onUpdate)

  frame.setAction = setAction

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
