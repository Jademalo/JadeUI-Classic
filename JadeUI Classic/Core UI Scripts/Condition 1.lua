--------------------------------------------
--Check for Classic or Retail
--------------------------------------------
isClassic = false

if WOW_PROJECT_ID == 2 then
    isClassic = true
end



--------------------------------------------
--Startup Chat Message
--------------------------------------------
function startupPrint()
    print ("~JadeUI~")
    if isClassic then
        print("Classic WoW Detected")
    else
        print("Retail WoW Detected")
    end
end



--------------------------------------------
--Set WeakAuras global config values
--------------------------------------------
blizzXPBar = aura_env.config.blizzXPBar
endstopType = aura_env.config.endstopType
mouseover = aura_env.config.mouseover
moveMinimap = aura_env.config.moveMinimap
minimapScale = aura_env.config.minimapScale
moveUnitFrames = aura_env.config.moveUnitFrames
stanceBarHide = aura_env.config.stanceBarHide
keyCover = aura_env.config.keyCover



--------------------------------------------
--Load all of the other relevant WeakAuras
--------------------------------------------
local mainBar = WeakAuras.GetRegion("MainBar")
local topBar = WeakAuras.GetRegion("TopBar")

local mouseoverMain = WeakAuras.GetRegion("MouseoverMain")
local mouseoverSmall = WeakAuras.GetRegion("MouseoverSmall")

local xpCover = WeakAuras.GetRegion("XPBarCover")

local xpBar = WeakAuras.GetRegion("XPBar")
local xpText = WeakAuras.GetRegion("XPBarTextMarker")

local repBar = WeakAuras.GetRegion("RepBar")
local repText = WeakAuras.GetRegion("RepBarText")

local repBarSmallCover = WeakAuras.GetRegion("RepBarSmallCover")
local repBarSmall = WeakAuras.GetRegion("RepBarSmall")
local repTextSmall = WeakAuras.GetRegion("RepBarTextSmall")

local jadeUI = WeakAuras.GetRegion("JadeUI Classic")
local buttonParent = WeakAuras.GetRegion("ButtonParent")



--------------------------------------------
--Frame Strata Functions for Mouseover
--------------------------------------------
function setFramesMain(strata)

    xpCover:SetFrameStrata(strata)

    xpBar:SetFrameStrata(strata)
    xpText:SetFrameStrata(strata)

    repBar:SetFrameStrata(strata)
    repText:SetFrameStrata(strata)

end

function setFramesSmall(strata)

    repBarSmallCover:SetFrameStrata(strata)

    repBarSmall:SetFrameStrata(strata)
    repTextSmall:SetFrameStrata(strata)

end

function setFramesBlizz(strata)

    xpCover:SetFrameStrata(strata)
    MainMenuExpBar:SetFrameStrata(strata)

end



--------------------------------------------
--Functions to move Blizzard Frames
--------------------------------------------
function moveUnitFramesFunc()
    --Player Frame
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrame:GetParent(), "BOTTOM", -163, 200)
    PlayerFrame.SetPoint = function()end

    --Target Frame
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrame:GetParent(), "BOTTOM", 162, 200)
    TargetFrame.SetPoint = function()end

    if not isClassic then
        --Focus Frame
        FocusFrame:ClearAllPoints()
        FocusFrame:SetPoint("BOTTOMLEFT", FocusFrame:GetParent(), "BOTTOM", -163, 250)
        FocusFrame.SetPoint = function()end
    end
end


function moveMinimapFunc()
    --Minimap
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("BOTTOMRIGHT", MinimapCluster:GetParent(), "BOTTOMRIGHT", 0, 0)
    MinimapCluster.SetPoint = function()end

    --Buff Bar
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", -13, -13)
    BuffFrame.SetPoint = function()end
end


function minimapScaleFunc()
    if minimapScale ~= 1 then
        MinimapCluster:SetScale(minimapScale)

        if not moveMinimap then
            local buffOffset = (MinimapCluster:GetWidth()*minimapScale) + 8

            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", -buffOffset, -13)
            BuffFrame.SetPoint = function()end
        end
    end
end


function moveCastingBar()
    --Casting Bar
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", CastingBarFrame:GetParent(), "BOTTOM", 0, 230)
    CastingBarFrame.SetPoint = function()end
end


function moveTutorialFrame()
    --Tutorial Frame
    TutorialFrameParent:ClearAllPoints()
    TutorialFrameParent:SetPoint("BOTTOM", TutorialFrameParent:GetParent(), "BOTTOM", 0, 230)
    TutorialFrameParent.SetPoint = function()end
end



function moveFramerateLabel()
    FramerateLabel:SetPoint("BOTTOM",FramerateLabel:GetParent(), "BOTTOM", 0, 200)
end


function moveBlizzXPBar()
    --Exp Bar
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetParent(jadeUI)
    MainMenuExpBar:SetPoint("BOTTOM", xpCover, "BOTTOM", 0, -3)
    MainMenuExpBar:SetWidth(586)
    MainMenuExpBar:SetFrameStrata("BACKGROUND")

    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()
end

--------------------------------------------
--Move Blizzard Action Bars
--------------------------------------------
function moveMicroMenu()
    --Micro Menu
    CharacterMicroButton:SetParent(buttonParent)
    SpellbookMicroButton:SetParent(buttonParent)
    if TalentMicroButton then
        TalentMicroButton:SetParent(buttonParent)
    end
    QuestLogMicroButton:SetParent(buttonParent)
    SocialsMicroButton:SetParent(buttonParent)
    WorldMapMicroButton:SetParent(buttonParent)
    MainMenuMicroButton:SetParent(buttonParent)
    HelpMicroButton:SetParent(buttonParent)
end


function moveBagBar()
    --Bag Bar
    CharacterMicroButton:SetPoint("BOTTOMLEFT", mainBar, "BOTTOM", -285, 2)
    MainMenuBarBackpackButton:SetParent(buttonParent)
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", mainBar, "BOTTOM", 293, 2)

    for i = 0, 3 do
        _G["CharacterBag" .. i .. "Slot"]:SetParent(buttonParent)
    end
end


function moveActionBars()
    --Main Action Bar
    ActionButton1:ClearAllPoints()
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetParent(buttonParent)
        _G["ActionButton" .. i]:SetFrameLevel(topBar:GetFrameLevel()+1)
    end
    ActionButton1:SetPoint("LEFT", topBar, "LEFT", 111, -63)

    --Bottom Left Action Bar
    local _, multiRel = MultiBarBottomLeft:GetPoint()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetParent(buttonParent)
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", multiRel, "TOPLEFT", 0, 7)
    --MultiBarBottomLeft.SetPoint = function()end

    --Bottom Right Action Bar
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetParent(buttonParent)
    MultiBarBottomRight:SetPoint("TOPLEFT", multiRel, "BOTTOMLEFT", 42, -5)

    --Bottom Right Action Bar Second Row
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "BOTTOMLEFT", 0, -5)

end


function moveStanceBar()
    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetParent(buttonParent)
    StanceBarFrame:SetPoint("BOTTOMLEFT", topBar, "TOPLEFT", 162, -120)
    --StanceBarFrame.SetPoint = function()end
end


function movePetBar()
    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetParent(buttonParent)
    PetActionBarFrame:SetScale(0.7)
    PetActionBarFrame:SetPoint("BOTTOMLEFT", topBar, "TOPLEFT", 144, -171)
    --PetActionBarFrame.SetPoint = function()end
end


function hideButtons()
    --Main Action Bar
    for i = 8, 12 do
        _G["ActionButton" .. i]:Hide()
        _G["MultiBarBottomLeftButton" .. i]:Hide()
    end

    --Bottom Right Action Bar
    MultiBarBottomRightButton6:Hide()
    MultiBarBottomRightButton7:Hide()
    MultiBarBottomRightButton11:Hide()
    MultiBarBottomRightButton12:Hide()
end
