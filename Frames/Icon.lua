
local FactoryInterface = { }
IFrameFactory("1.0"):Register("Rotation", "Icon", FactoryInterface)

function FactoryInterface:Create()
  local frame = CreateFrame("Frame", nil, UIParent)

  local width, height = 22, 22
  frame:SetWidth(width); frame:SetHeight(height)

  frame.Texture = frame:CreateTexture(nil, "ARTWORK")
  frame.Texture:SetWidth(width - 4); frame.Texture:SetHeight(height - 4)
  frame.Texture:SetPoint("CENTER", frame, "CENTER", 0, 0)

  frame.Border = frame:CreateTexture(nil, "Background")
  frame.Border:SetWidth(width); frame.Border:SetHeight(height)
  frame.Border:SetTexture(0, 0, 0, 1)
  frame.Border:SetPoint("CENTER", frame, "CENTER", 0, 0)

  -- Border is created by !Beautycase.
  frame:CreateBorder(6)
  frame:SetBorderColor(1, 1, 1, 1)

  function frame.setTexture(self, name)
    self.Texture:SetTexture("Interface\\AddOns\\Rotation\\Textures\\"..name..".tga")
    self.Texture:SetVertexColor(1, 1, 0)
  end

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
