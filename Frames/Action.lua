
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

local function availableAt(self)
  local start, duration = GetSpellCooldown(self.spellID, self.spellBookType)
  return start and start + duration or 0
end

local function getPriority(self)
  return self.calculatePriority()
end

local function setAction(self, config)
  self.config = config

  -- Store the spell book type and ID
  self.spellBookType, self.spellID = findSpellByName(config[1])
  local tex = GetSpellTexture(self.spellID, self.spellBookType)
  self.texture:SetTexture(tex)

  -- Load the priority function
  local functionString = "return function() return "..self.config[2].."; end"
  self.calculatePriority = loadstring(functionString)()

  -- Restrict the execution environment to our special one
  setfenv(self.calculatePriority, RotationConfigEnvironment)
end

local function doHighlight(self, state)
  if state == "high" then
    self.Flash:SetVertexColor(1.0, 0.0, 0.0);
    self.Flash:SetAlpha(1)
    self.Flash:Show()
  elseif state == "medium" then
    self.Flash:SetVertexColor(1.0, 1.0, 0.0);
    self.Flash:SetAlpha(1)
    self.Flash:Show()
  else
    self.Flash:SetVertexColor(0.0, 1.0, 0.0);
    self.Flash:SetAlpha(0)
    self.Flash:Hide()
  end
end

local function onEvent(self, event, ...)
  local start, duration = GetSpellCooldown(self.spellID, self.spellBookType)
  self.coolDownEnd = start and start + duration or nil
end

local function onUpdate(self, elapsed)
  -- There is no event which fires when a cooldown expires :(
  if self.coolDownEnd and self.coolDownEnd < GetTime() then
    self.coolDownEnd = Rotation:Update()
  end
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

  frame.Flash = frame:CreateTexture(nil, "OVERLAY")
  frame.Flash:SetPoint("CENTER", frame)
  frame.Flash:SetTexture("Interface\\AddOns\\Rotation\\Textures\\Flash")
  frame.Flash:SetVertexColor(0.0, 1.0, 0.0)

  frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")

  frame:SetScript("OnEvent", onEvent)
  frame:SetScript("OnUpdate", onUpdate)

  frame.setAction = setAction

  frame.availableAt = availableAt
  frame.getPriority = getPriority

  frame.doHighlight = doHighlight

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
