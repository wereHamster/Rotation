
local FactoryInterface = { }
IFrameFactory("1.0"):Register("Rotation", "Bar", FactoryInterface)

-- This code is shamelessly stolen from the official casting bar UI

local function showBar(self, startTime, endTime)
  self:SetAlpha(1.0);
  self:Show();

  self.value = GetTime() - startTime;
  self.maxValue = endTime - startTime;

  self.Bar:SetMinMaxValues(0, self.maxValue);
  self.Bar:SetValue(self.value);

  self.holdTime = 0;
  self.channeling = 1;
  self.fadeOut = nil;
end

local function finishSpell(self)
    self.holdTime = GetTime() + 0.3;
    --self.fadeOut = 0.2;
    self.channeling = nil;
end

local function onUpdate(self, elapsed)
  if ( self.channeling ) then
      self.value = self.value + elapsed;
      self.Bar:SetValue(self.value);

      if self.value >= self.maxValue then
          finishSpell(self);
          return;
      end
  elseif ( GetTime() < self.holdTime ) then
      return;
  elseif ( self.fadeOut ) then
      local alpha = self:GetAlpha() - 1.0 / ( GetFramerate() * self.fadeOut );
      if ( alpha > 0 ) then
          self:SetAlpha(alpha);
      else
          self.fadeOut = nil;
          self:Hide();
      end
  end
end

function FactoryInterface:Create()
  local frame = CreateFrame("Frame", nil, UIParent)
  frame:SetHeight(22)

  frame.Background = frame:CreateTexture(nil, "ARTWORK")
  frame.Background:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
  frame.Background:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
  frame.Background:SetTexture(1, 1, 0, 0.7)

  frame.Black = frame:CreateTexture(nil, "OVERLAY")
  frame.Black:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4)
  frame.Black:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
  frame.Black:SetTexture(0, 0, 0, 1)

  frame.Bar = CreateFrame("StatusBar", nil, frame)
  frame.Bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, 3)
  frame.Bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
  frame.Bar:SetStatusBarTexture("Interface\\AddOns\\Rotation\\Textures\\Smooth")
  frame.Bar:SetStatusBarColor(1, 1, 0, 1)

  frame.Border = CreateFrame("Frame", nil, frame)
  frame.Border:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
  frame.Border:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
  frame.Border:CreateBorder(6)
  frame.Border:SetBorderColor(0, 0, 0, 1)

  frame:SetScript("OnUpdate", onUpdate)

  frame.showBar = showBar
  finishSpell(frame)

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
