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
   stanceBarTexture = "Interface/AddOns/JadeUI-Classic/Media/background/G13Classic/StanceBar/StanceBar1.tga",
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
   endCapGryphonTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf",
   endCapLionTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Human"
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
   JadeUIBarLeftEndCap:SetTexture(textures.endCapGryphonTexture)
   JadeUIBarLeftEndCap:SetDrawLayer("ARTWORK")

   JadeUIBarRightEndCap = JadeUIBarArtFrame:CreateTexture("JadeUIBarRightEndCap")
   JadeUIBarRightEndCap:SetPoint("BOTTOMLEFT", JadeUIBarArtFrame, "BOTTOMRIGHT", -32, 0)
   JadeUIBarRightEndCap:SetTexture(textures.endCapGryphonTexture)
   JadeUIBarRightEndCap:SetTexCoord(1, 0, 0, 1) --Mirror Texture
   JadeUIBarRightEndCap:SetDrawLayer("ARTWORK")


   JadeUIBarTopArtFrame = CreateFrame("Frame","JadeUIBarTopArtFrame", JadeUIBarArtFrame)
   JadeUIBarTopArtFrame:SetPoint("BOTTOM", JadeUIBarArtFrame, "TOP", -2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopArtFrame:SetSize(309, 136)

   JadeUIBarTopTexture = JadeUIBarTopArtFrame:CreateTexture("JadeUIBarTopTexture")
   JadeUIBarTopTexture:SetPoint("BOTTOM", JadeUIBarTopArtFrame, "BOTTOM", 2, 0) --This offset is specifically to line up the frame with the art
   JadeUIBarTopTexture:SetTexture(textures.g13TopBarTexture)
   JadeUIBarTopTexture:SetDrawLayer("BACKGROUND", 0)


--[[    JadeUIPetBarTexture = JadeUIBarArtFrame:CreateTexture("JadeUIPetBarTexture")
   JadeUIPetBarTexture:SetParent(PetActionBar) --This seems to break the size of the pet bar if set to PetActionBar
   JadeUIPetBarTexture:SetPoint("BOTTOM", PetActionBar, "BOTTOM", 3, -1)
   JadeUIPetBarTexture:SetTexture(textures.petBarTexture) ]]

   JadeUIStanceBarTexture = JadeUIBarArtFrame:CreateTexture("JadeUIStanceBarTexture")
   JadeUIStanceBarTexture:SetParent(StanceBar)
   JadeUIStanceBarTexture:SetPoint("BOTTOMLEFT", StanceBar, "BOTTOMLEFT", -10, -4)
   JadeUIStanceBarTexture:SetTexture(textures.stanceBarTexture)
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


