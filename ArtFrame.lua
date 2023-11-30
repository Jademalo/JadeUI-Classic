--------------------------------------------
--Variables
--------------------------------------------
local name, JadeUI = ...

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

local endstopTexture = "Interface/MAINMENUBAR/UI-MainMenuBar-EndCap-Dwarf"

--------------------------------------------
--Functions
--------------------------------------------
function JadeUI.createArtFrame()
    local g13MainBar = JadeUIBar:CreateTexture()
    g13MainBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM")
    g13MainBar:SetTexture(g13MainBarTexture)
    g13MainBar:SetDrawLayer("BACKGROUND", 0)

    local g13TopBar = JadeUIBar:CreateTexture()
    g13TopBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    g13TopBar:SetTexture(g13TopBarTexture)
    g13TopBar:SetDrawLayer("BACKGROUND", 0)


    local leftEndstop = JadeUIBar:CreateTexture()
    leftEndstop:SetPoint("BOTTOMRIGHT", JadeUIBar, "BOTTOM", -268, 0)
    leftEndstop:SetTexture(endstopTexture)
    leftEndstop:SetDrawLayer("BACKGROUND", 1)

    local rightEndstop = JadeUIBar:CreateTexture()
    rightEndstop:SetPoint("BOTTOMLEFT", JadeUIBar, "BOTTOM", 268, 0)
    rightEndstop:SetTexture(endstopTexture)
    rightEndstop:SetTexCoord(1, 0, 0, 1) --Mirror Texture
    rightEndstop:SetDrawLayer("BACKGROUND", 1)


    local g13XPBar = JadeUIBar:CreateTexture()
    g13XPBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    g13XPBar:SetTexture(g13XPBarTexture)
    g13XPBar:SetDrawLayer("BACKGROUND", -3)

    local g13RepBar = JadeUIBar:CreateTexture()
    g13RepBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 51)
    g13RepBar:SetTexture(g13RepBarTexture)
    g13RepBar:SetDrawLayer("BACKGROUND", -2)

    local g13MaxCover = JadeUIBar:CreateTexture()
    g13MaxCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    g13MaxCover:SetTexture(g13MaxCoverTexture)
    g13MaxCover:SetDrawLayer("BACKGROUND", -1)


    local petBar = JadeUIBar:CreateTexture()
    petBar:SetParent(PetActionBarFrame)
    petBar:SetPoint("LEFT", PetActionBarFrame, "LEFT", 0, 8.5)
    petBar:SetTexture(petBarTexture)



end