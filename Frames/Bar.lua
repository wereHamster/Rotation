
local FactoryInterface = { }
IFrameFactory("1.0"):Register("Rotation", "Bar", FactoryInterface)

-- This code is shamelessly stolen from the official casting bar UI

local function showBar(self, startTime, endTime)
  self:SetAlpha(1.0);
  self:Show();

  self.value = endTime - GetTime();
  self.maxValue = endTime - startTime;

  self.Bar:SetStatusBarColor(0.0, 1.0, 0.0);
  self.Bar:SetMinMaxValues(0, self.maxValue);
  self.Bar:SetValue(self.value);

  self.holdTime = 0;
  self.channeling = 1;
  self.fadeOut = nil;
end

local function finishSpell(self)
    self.Bar:SetStatusBarColor(0.0, 1.0, 0.0);

    self.holdTime = GetTime() + 0.3;
    self.fadeOut = 0.2;
    self.channeling = nil;
end

local function onUpdate(self, elapsed)
  if ( self.channeling ) then
      self.value = self.value - elapsed;
      self.Bar:SetValue(self.value);

      if ( self.value <= 0 ) then
          finishSpell(self);
          return;
      end

      self.Bar:SetValue(self.value);
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

  frame:SetWidth(200)
  frame:SetHeight(26)

  local backdropTable = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 12, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
  }

  frame:SetBackdrop(backdropTable)
  frame:SetBackdropBorderColor(0, 0, 0, 1)
  frame:SetBackdropColor(0, 0, 0, 1)

  frame.Bar = CreateFrame("StatusBar", nil, frame)
  frame.Bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 6)
  frame.Bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
  frame.Bar:SetStatusBarTexture("Interface\\AddOns\\Serenity\\Textures\\Solid")
  frame.Bar:SetStatusBarColor(0.4, 0.4, 0.95, 1)

  frame:SetScript("OnUpdate", onUpdate)

  frame.showBar = showBar
  finishSpell(frame)

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
