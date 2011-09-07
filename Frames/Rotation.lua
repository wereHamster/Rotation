
local FactoryInterface = { }
IFrameFactory("1.0"):Register("Rotation", "Rotation", FactoryInterface)

function FactoryInterface:Create()
  local frame = CreateFrame("Frame", "RotationFrame", UIParent)

  local width, height = 122, 66
  frame:SetWidth(width); frame:SetHeight(height)

  -- The frame background.
  frame.Border = frame:CreateTexture(nil, "BACKGROUND")
  frame.Border:SetWidth(width); frame.Border:SetHeight(height)
  frame.Border:SetTexture(0, 0, 0, 0.8)
  frame.Border:SetPoint("CENTER", frame, "CENTER", 0, 0)

  -- Border is created by !Beautycase.
  frame:CreateBorder(6)
  frame:SetBorderColor(0, 0, 0, 1)

  -- Two icons in the lower left corner.
  frame.Icon = { }
  frame.Icon[1] = IFrameFactory("1.0"):Create("Rotation", "Icon")
  frame.Icon[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
  frame.Icon[2] = IFrameFactory("1.0"):Create("Rotation", "Icon")
  frame.Icon[2]:SetPoint("LEFT", frame.Icon[1], "RIGHT", 0, 0)

  -- The bar right of the icons until the right edge.
  frame.Bar = IFrameFactory("1.0"):Create("Rotation", "Bar")
  frame.Bar:SetPoint("LEFT", frame.Icon[2], "RIGHT", 2, 0)
  frame.Bar:SetPoint("RIGHT", frame, "RIGHT", -2, 0)

  function frame.setAction(idx, action)
    action:ClearAllPoints()
    action:SetPoint("TOPLEFT", frame, "TOPLEFT", (idx - 1) * 40 + 2, -2)
  end

  function frame.setPreset(icon1, icon2)
    frame.Icon[1]:setTexture(icon1)
    frame.Icon[2]:setTexture(icon2)
  end

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
