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
   g13ExpBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/G13XPBar.tga",
   petBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/PetBar.tga",
   endCapGryphonTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf",
   endCapLionTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Human"
}
--@end-debug@

--[===[@non-debug@
JadeUI.textures = {
   g13MainBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MainBar.tga",
   g13MaxCoverTexture = "Interface/AddOns/JadeUI-Classic/Media/G13MaxCover.tga",
   g13RepBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13RepBar.tga",
   g13TopBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13TopBar.tga",
   g13ExpBarTexture = "Interface/AddOns/JadeUI-Classic/Media/G13XPBar.tga",
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

   JadeUIBarArtFrame = CreateFrame("Frame","JadeUIBarArtFrame", JadeUIBar)
   JadeUIBarArtFrame:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 0)
   JadeUIBarArtFrame:SetSize(598, 43)

   JadeUIBarTexture = JadeUIBarArtFrame:CreateTexture("JadeUIBarTexture")
   JadeUIBarTexture:SetPoint("BOTTOM", JadeUIBarArtFrame, "BOTTOM")
   JadeUIBarTexture:SetTexture(textures.g13MainBarTexture)
   JadeUIBarTexture:SetDrawLayer("BACKGROUND", -6)

   JadeUIBarLeftEndCap = JadeUIBarArtFrame:CreateTexture("JadeUIBarLeftEndCap")
   JadeUIBarLeftEndCap:SetPoint("BOTTOMRIGHT", JadeUIBarArtFrame, "BOTTOMLEFT", 32, 0)
   JadeUIBarLeftEndCap:SetTexture(textures.endstopDwarfTexture)
   JadeUIBarLeftEndCap:SetDrawLayer("ARTWORK")

   JadeUIBarRightEndCap = JadeUIBarArtFrame:CreateTexture("JadeUIBarRightEndCap")
   JadeUIBarRightEndCap:SetPoint("BOTTOMLEFT", JadeUIBarArtFrame, "BOTTOMRIGHT", -32, 0)
   JadeUIBarRightEndCap:SetTexture(textures.endstopDwarfTexture)
   JadeUIBarRightEndCap:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   JadeUIBarRightEndCap:SetDrawLayer("ARTWORK")


   JadeUIBarTopArtFrame = CreateFrame("Frame","JadeUIBarTopArtFrame", JadeUIBarArtFrame)
   JadeUIBarTopArtFrame:SetPoint("BOTTOM", JadeUIBarArtFrame, "TOP", -2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopArtFrame:SetSize(309, 136)

   JadeUIBarTopTexture = JadeUIBarTopArtFrame:CreateTexture("JadeUIBarTopTexture")
   JadeUIBarTopTexture:SetPoint("BOTTOM", JadeUIBarTopArtFrame, "BOTTOM", 2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopTexture:SetTexture(textures.g13TopBarTexture)
   JadeUIBarTopTexture:SetDrawLayer("BACKGROUND", 0)


   JadeUIPetBarTexture = JadeUIBarArtFrame:CreateTexture("JadeUIPetBarTexture")
   JadeUIPetBarTexture:SetParent(PetActionBarFrame)
   JadeUIPetBarTexture:SetPoint("BOTTOM", PetActionBarFrame, "BOTTOM", 3, -1)
   JadeUIPetBarTexture:SetTexture(textures.petBarTexture)
end


--[[ MEDIUM
    Level 13    - MultiBarBottomLeftButtons + MultiBarBottomRightButtons
    Level 12    - ActionButtons + MultiBarBottomRight + MultiBarBottomLeft
    Level 11    - JadeUIButtonParent
    Level 10    - 
    Level 9     - JadeUIBarArtPanel + JadeUIBarTopArtFrame                  - Must be on top of the Exp bar
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
   JadeUIBarTopArtFrame:SetFrameLevel(9)
   JadeUIBarArtFrame:SetFrameLevel(9)
   ExhaustionTick:SetFrameLevel(4)
   MainMenuExpBar:SetFrameLevel(3)
   ReputationWatchBar:SetFrameLevel(2)
end

--Sets the endstop texture based on a variable passed to it
function JadeUI.setEndstop(type)
   if type == 0 then
      JadeUIBarRightEndCap:SetTexture(textures.endCapGryphonTexture)
      JadeUIBarLeftEndCap:SetTexture(textures.endCapGryphonTexture)
      JadeUIBarRightEndCap:Show()
      JadeUIBarLeftEndCap:Show()

   elseif type == 1 then
      JadeUIBarRightEndCap:SetTexture(textures.endCapLionTexture)
      JadeUIBarLeftEndCap:SetTexture(textures.endCapLionTexture)
      JadeUIBarRightEndCap:Show()
      JadeUIBarLeftEndCap:Show()

   elseif type == 2 then
      JadeUIBarRightEndCap:Hide()
      JadeUIBarLeftEndCap:Hide()

   end
end


