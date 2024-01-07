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
function JadeUI.createArtFrame()

   JadeUIBarArtPanel = CreateFrame("Frame","Jade UI Art Panel", JadeUIBar)
   JadeUIBarArtPanel:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 0)
   JadeUIBarArtPanel:SetSize(598, 43)

   JadeUI.g13MainBar = JadeUIBarArtPanel:CreateTexture("JadeUI Main Bar Texture")
   JadeUI.g13MainBar:SetPoint("BOTTOM", JadeUIBarArtPanel, "BOTTOM")
   JadeUI.g13MainBar:SetTexture(textures.g13MainBarTexture)
   JadeUI.g13MainBar:SetDrawLayer("BACKGROUND", -6)

   JadeUI.leftEndstop = JadeUIBarArtPanel:CreateTexture("JadeUI Left Endstop")
   JadeUI.leftEndstop:SetPoint("BOTTOMRIGHT", JadeUIBarArtPanel, "BOTTOMLEFT", 32, 0)
   --JadeUI.leftEndstop:SetTexture(textures.endstopDwarfTexture)
   JadeUI.leftEndstop:SetDrawLayer("ARTWORK")

   JadeUI.rightEndstop = JadeUIBarArtPanel:CreateTexture("JadeUI Right Endstop")
   JadeUI.rightEndstop:SetPoint("BOTTOMLEFT", JadeUIBarArtPanel, "BOTTOMRIGHT", -32, 0)
   --JadeUI.rightEndstop:SetTexture(textures.endstopDwarfTexture)
   JadeUI.rightEndstop:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   JadeUI.rightEndstop:SetDrawLayer("ARTWORK")


   JadeUI.petBar = JadeUIBarArtPanel:CreateTexture("JadeUI Pet Bar Texture")
   JadeUI.petBar:SetParent(PetActionBarFrame)
   JadeUI.petBar:SetPoint("BOTTOM", PetActionBarFrame, "BOTTOM", 3, -1)
   JadeUI.petBar:SetTexture(textures.petBarTexture)





   JadeUIBarTopArtPanel = CreateFrame("Frame","Jade UI Top Art Panel", JadeUIBarArtPanel)
   JadeUIBarTopArtPanel:SetPoint("BOTTOM", JadeUIBarArtPanel, "TOP", -2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopArtPanel:SetSize(309, 136)

   JadeUI.g13TopBar = JadeUIBarTopArtPanel:CreateTexture("JadeUI Top Bar Texture")
   JadeUI.g13TopBar:SetPoint("BOTTOM", JadeUIBarTopArtPanel, "BOTTOM", 2, 0) --This offset is specifically to line up the frame with the art
   JadeUI.g13TopBar:SetTexture(textures.g13TopBarTexture)
   JadeUI.g13TopBar:SetDrawLayer("BACKGROUND", 0)
end


--[[ MEDIUM
    Level 13    - MultiBarBottomLeftButtons + MultiBarBottomRightButtons
    Level 12    - ActionButtons + MultiBarBottomRight + MultiBarBottomLeft
    Level 11    - JadeUIButtonParent
    Level 10    - MultiBarBottomRightButton8/9/10
    Level 9     - JadeUIBarArtPanel + JadeUIBarTopArtPanel                  - Must be on top of the Exp bar
    Level 8     - 
    Level 7     - 
    Level 6     - 
    Level 5     - 
    Level 4     - ExhaustionTick
    Level 3     - MainMenuExpBar                                            - Must be on top of the Rep bar
    Level 2     - ReputationWatchBar
    Level 1     - JadeUIBar (Invisible parent)
    Level 0     - UIParent
 ]]
--Set the frame strata to standard values for correct layering
function JadeUI.SetDefaultStrata()
   MultiBarBottomRight:SetFrameLevel(JadeUIButtonParent:GetFrameLevel()+1) --Children are given +1 to their parent by default
   JadeUIButtonParent:SetFrameLevel(11)
   JadeUIBarTopArtPanel:SetFrameLevel(9)
   JadeUIBarArtPanel:SetFrameLevel(9)
   ExhaustionTick:SetFrameLevel(4)
   MainMenuExpBar:SetFrameLevel(3)
   ReputationWatchBar:SetFrameLevel(2)
end

--Sets the endstop texture based on a variable passed to it
function JadeUI.setEndstop(type)
   if type == 0 then
      JadeUI.rightEndstop:SetTexture(textures.endstopGryphonTexture)
      JadeUI.leftEndstop:SetTexture(textures.endstopGryphonTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   elseif type == 1 then
      JadeUI.rightEndstop:SetTexture(textures.endstopLionTexture)
      JadeUI.leftEndstop:SetTexture(textures.endstopLionTexture)
      JadeUI.rightEndstop:Show()
      JadeUI.leftEndstop:Show()

   elseif type == 2 then
      JadeUI.rightEndstop:Hide()
      JadeUI.leftEndstop:Hide()

   end
end


