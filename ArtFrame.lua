--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Artwork
--------------------------------------------
--@debug@
local g13MainBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13MainBar.tga"
local g13MaxCoverTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13MaxCover.tga"
local g13RepBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13RepBar.tga"
local g13TopBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13TopBar.tga"
local g13XPBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13XPBar.tga"
local petBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/PetBar.tga"
--@end-debug@

--[===[@non-debug@
local g13MainBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MainBar.tga"
local g13MaxCoverTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MaxCover.tga"
local g13RepBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13RepBar.tga"
local g13TopBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13TopBar.tga"
local g13XPBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13XPBar.tga"
local petBarTexture = "Interface/AddOns/JadeUI-Classic/Media/PetBar.tga"
--@end-non-debug@]===]

JadeUI.endstopGryphonTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf"
JadeUI.endstopLionTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Human"

--------------------------------------------
--Functions
--------------------------------------------
function JadeUI.createArtFrame()
   JadeUI.g13MainBar = JadeUIBar:CreateTexture()
   JadeUI.g13MainBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM")
   JadeUI.g13MainBar:SetTexture(g13MainBarTexture)
   JadeUI.g13MainBar:SetDrawLayer("BACKGROUND", 0)

   JadeUI.g13TopBar = JadeUIBar:CreateTexture()
   JadeUI.g13TopBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
   JadeUI.g13TopBar:SetTexture(g13TopBarTexture)
   JadeUI.g13TopBar:SetDrawLayer("BACKGROUND", 0)


   JadeUI.leftEndstop = JadeUIBar:CreateTexture()
   JadeUI.leftEndstop:SetPoint("BOTTOMRIGHT", JadeUIBar, "BOTTOM", -267, 0)
   JadeUI.leftEndstop:SetTexture(JadeUI.endstopDwarfTexture)
   JadeUI.leftEndstop:SetDrawLayer("BACKGROUND", 1)

   JadeUI.rightEndstop = JadeUIBar:CreateTexture()
   JadeUI.rightEndstop:SetPoint("BOTTOMLEFT", JadeUIBar, "BOTTOM", 267, 0)
   JadeUI.rightEndstop:SetTexture(JadeUI.endstopDwarfTexture)
   JadeUI.rightEndstop:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   JadeUI.rightEndstop:SetDrawLayer("BACKGROUND", 1)


   JadeUI.g13XPBar = JadeUIBar:CreateTexture()
   JadeUI.g13XPBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
   JadeUI.g13XPBar:SetTexture(g13XPBarTexture)
   JadeUI.g13XPBar:SetDrawLayer("BACKGROUND", -3)

   JadeUI.g13RepBar = JadeUIBar:CreateTexture()
   JadeUI.g13RepBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 51)
   JadeUI.g13RepBar:SetTexture(g13RepBarTexture)
   JadeUI.g13RepBar:SetDrawLayer("BACKGROUND", -2)

   JadeUI.g13MaxCover = JadeUIBar:CreateTexture()
   JadeUI.g13MaxCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
   JadeUI.g13MaxCover:SetTexture(g13MaxCoverTexture)
   JadeUI.g13MaxCover:SetDrawLayer("BACKGROUND", -1)


   JadeUI.petBar = JadeUIBar:CreateTexture()
   JadeUI.petBar:SetParent(PetActionBarFrame)
   JadeUI.petBar:SetPoint("LEFT", PetActionBarFrame, "LEFT", 0, 8.5)
   JadeUI.petBar:SetTexture(petBarTexture)

end


--Sets the endstop texture based on a variable passed to it
function JadeUI.setEndstop(type)
   if type == 0 then
      JadeUI.rightEndstop:Hide()
      JadeUI.leftEndstop:Hide()

   elseif type == 1 then
      JadeUI.rightEndstop:SetTexture(JadeUI.endstopGryphonTexture)
      JadeUI.leftEndstop:SetTexture(JadeUI.endstopGryphonTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   elseif type == 2 then
      JadeUI.rightEndstop:SetTexture(JadeUI.endstopLionTexture)
      JadeUI.leftEndstop:SetTexture(JadeUI.endstopLionTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   end
end

--Show/Hide the Max level cover depending on your level or tracked faction status
function JadeUI.showXPCover()
   if UnitLevel("player") < GetMaxPlayerLevel() or GetWatchedFactionInfo() then
       JadeUI.g13MaxCover:Hide()
   else
       JadeUI.g13MaxCover:Show()
   end
end
