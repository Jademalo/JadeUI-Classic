--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Artwork
--------------------------------------------
--@debug@
JadeUI.textures = {
   g13MainBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13MainBar.tga",
   g13MaxCoverTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13MaxCover.tga",
   g13RepBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13RepBar.tga",
   g13TopBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13TopBar.tga",
   g13XPBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13XPBar.tga",
   petBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/PetBar.tga",
   endstopGryphonTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf",
   endstopLionTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Human"
}
--@end-debug@

--[===[@non-debug@
JadeUI.textures = {
   g13MainBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MainBar.tga",
   g13MaxCoverTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MaxCover.tga",
   g13RepBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13RepBar.tga",
   g13TopBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13TopBar.tga",
   g13XPBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13XPBar.tga",
   petBarTexture = "Interface/AddOns/JadeUI-Classic/Media/PetBar.tga",
   endstopGryphonTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf",
   endstopLionTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Human"
}
--@end-non-debug@]===]

local textures = JadeUI.textures

--------------------------------------------
--Functions
--------------------------------------------
local function addPanel(name, point, relativePoint, offsetX, offsetY, texture, layer, sublevel)
   panel = JadeUIBar:CreateTexture(name)
   panel:SetPoint(point, JadeUIBarArtFrame, relativePoint, offsetX, offsetY)
   return panel
end





function JadeUI.createArtFrame()

   JadeUIBarArtPanel = CreateFrame("Frame","Jade UI Art Panel", JadeUIBar)
   JadeUIBarArtPanel:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 0)
   JadeUIBarArtPanel:SetSize(745, 210)

   JadeUI.g13MainBar = JadeUIBarArtPanel:CreateTexture("JadeUI Main Bar Texture")
   JadeUI.g13MainBar:SetPoint("BOTTOM", JadeUIBarArtPanel, "BOTTOM")
   JadeUI.g13MainBar:SetTexture(textures.g13MainBarTexture)
   JadeUI.g13MainBar:SetDrawLayer("BACKGROUND", -6)

   JadeUI.g13TopBar = JadeUIBarArtPanel:CreateTexture("JadeUI Top Bar Texture")
   JadeUI.g13TopBar:SetPoint("BOTTOM", JadeUIBarArtPanel, "BOTTOM", 0, 43)
   JadeUI.g13TopBar:SetTexture(textures.g13TopBarTexture)
   JadeUI.g13TopBar:SetDrawLayer("BACKGROUND", 0)


   JadeUI.leftEndstop = JadeUIBarArtPanel:CreateTexture("JadeUI Left Endstop")
   JadeUI.leftEndstop:SetPoint("BOTTOMRIGHT", JadeUIBarArtPanel, "BOTTOM", -267, 0)
   JadeUI.leftEndstop:SetTexture(textures.endstopDwarfTexture)
   JadeUI.leftEndstop:SetDrawLayer("ARTWORK")

   JadeUI.rightEndstop = JadeUIBarArtPanel:CreateTexture("JadeUI Right Endstop")
   JadeUI.rightEndstop:SetPoint("BOTTOMLEFT", JadeUIBarArtPanel, "BOTTOM", 267, 0)
   JadeUI.rightEndstop:SetTexture(textures.endstopDwarfTexture)
   JadeUI.rightEndstop:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   JadeUI.rightEndstop:SetDrawLayer("ARTWORK")





   JadeUI.petBar = JadeUIBar:CreateTexture("JadeUI Pet Bar Texture")
   JadeUI.petBar:SetParent(PetActionBarFrame)
   JadeUI.petBar:SetPoint("LEFT", PetActionBarFrame, "LEFT", 0, 8.5)
   JadeUI.petBar:SetTexture(textures.petBarTexture)

end


--Sets the endstop texture based on a variable passed to it
function JadeUI.setEndstop(type)
   if type == 0 then
      JadeUI.rightEndstop:Hide()
      JadeUI.leftEndstop:Hide()

   elseif type == 1 then
      JadeUI.rightEndstop:SetTexture(textures.endstopGryphonTexture)
      JadeUI.leftEndstop:SetTexture(textures.endstopGryphonTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   elseif type == 2 then
      JadeUI.rightEndstop:SetTexture(textures.endstopLionTexture)
      JadeUI.leftEndstop:SetTexture(textures.endstopLionTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   end
end


