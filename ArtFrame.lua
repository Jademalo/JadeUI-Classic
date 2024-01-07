--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Artwork Textures
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

   JadeUIBarArtPanel = CreateFrame("Frame","JadeUIBarArtFrame", JadeUIBar)
   JadeUIBarArtPanel:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 0)
   JadeUIBarArtPanel:SetSize(598, 43)

   local g13MainBar = JadeUIBarArtPanel:CreateTexture("JadeUIBarTexture")
   g13MainBar:SetPoint("BOTTOM", JadeUIBarArtPanel, "BOTTOM")
   g13MainBar:SetTexture(textures.g13MainBarTexture)
   g13MainBar:SetDrawLayer("BACKGROUND", -6)

   local leftEndstop = JadeUIBarArtPanel:CreateTexture("JadeUIBarLeftEndCap")
   leftEndstop:SetPoint("BOTTOMRIGHT", JadeUIBarArtPanel, "BOTTOMLEFT", 32, 0)
   leftEndstop:SetTexture(textures.endstopDwarfTexture)
   leftEndstop:SetDrawLayer("ARTWORK")

   local rightEndstop = JadeUIBarArtPanel:CreateTexture("JadeUIBarRightEndCap")
   rightEndstop:SetPoint("BOTTOMLEFT", JadeUIBarArtPanel, "BOTTOMRIGHT", -32, 0)
   rightEndstop:SetTexture(textures.endstopDwarfTexture)
   rightEndstop:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   rightEndstop:SetDrawLayer("ARTWORK")


   JadeUIBarTopArtPanel = CreateFrame("Frame","JadeUIBarTopArtFrame", JadeUIBarArtPanel)
   JadeUIBarTopArtPanel:SetPoint("BOTTOM", JadeUIBarArtPanel, "TOP", -2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopArtPanel:SetSize(309, 136)

   local g13TopBar = JadeUIBarTopArtPanel:CreateTexture("JadeUIBarTopTexture")
   g13TopBar:SetPoint("BOTTOM", JadeUIBarTopArtPanel, "BOTTOM", 2, 0) --This offset is specifically to line up the frame with the art
   g13TopBar:SetTexture(textures.g13TopBarTexture)
   g13TopBar:SetDrawLayer("BACKGROUND", 0)


   local petBar = JadeUIBarArtPanel:CreateTexture("JadeUIPetBarTexture")
   petBar:SetParent(PetActionBarFrame)
   petBar:SetPoint("BOTTOM", PetActionBarFrame, "BOTTOM", 3, -1)
   petBar:SetTexture(textures.petBarTexture)
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
      JadeUIBarRightEndCap:SetTexture(textures.endstopGryphonTexture)
      JadeUIBarLeftEndCap:SetTexture(textures.endstopGryphonTexture)
      JadeUIBarRightEndCap:Show()
      JadeUIBarLeftEndCap:Show()

   elseif type == 1 then
      JadeUIBarRightEndCap:SetTexture(textures.endstopLionTexture)
      JadeUIBarLeftEndCap:SetTexture(textures.endstopLionTexture)
      JadeUIBarRightEndCap:Show()
      JadeUIBarLeftEndCap:Show()

   elseif type == 2 then
      JadeUIBarRightEndCap:Hide()
      JadeUIBarLeftEndCap:Hide()

   end
end


