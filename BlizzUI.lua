--------------------------------------------
--Variables
--------------------------------------------
local name, JadeUI = ...


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
local function moveUnitFramesFunc()
    --Player Frame
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrame:GetParent(), "BOTTOM", - 163, 200)
    PlayerFrame.SetPoint = function()end

    --Target Frame
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrame:GetParent(), "BOTTOM", 162, 200)
    TargetFrame.SetPoint = function()end

    if not JadeUI.isVanilla then
        --Focus Frame
        FocusFrame:ClearAllPoints()
        FocusFrame:SetPoint("BOTTOMLEFT", FocusFrame:GetParent(), "BOTTOM", - 163, 250)
        FocusFrame.SetPoint = function()end
    end
end


local function moveMinimapFunc()
    --Minimap
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("BOTTOMRIGHT", MinimapCluster:GetParent(), "BOTTOMRIGHT", 0, 0)
    MinimapCluster.SetPoint = function()end

    --Buff Bar
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - 13, - 13)
    BuffFrame.SetPoint = function()end
end


local function minimapScaleFunc()
    if minimapScale ~= 1 then
        MinimapCluster:SetScale(minimapScale)

        if not moveMinimap then
            local buffOffset = (MinimapCluster:GetWidth() * minimapScale) + 8

            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - buffOffset, - 13)
            BuffFrame.SetPoint = function()end
        end
    end
end


local function moveCastingBar()
    --Casting Bar
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", CastingBarFrame:GetParent(), "BOTTOM", 0, 248)
    CastingBarFrame.SetPoint = function()end
end


local function moveTutorialFrame()
    --Tutorial Frame
    TutorialFrameParent:ClearAllPoints()
    TutorialFrameParent:SetPoint("BOTTOM", TutorialFrameParent:GetParent(), "BOTTOM", 0, 300)
    TutorialFrameParent.SetPoint = function()end
end



local function moveFramerateLabel()
    FramerateLabel:SetPoint("BOTTOM", FramerateLabel:GetParent(), "BOTTOM", - 190, 85)
end



--------------------------------------------
--Functions to move Blizzard Action Bars
--------------------------------------------

local function moveMicroMenu()
    --Micro Menu
    CharacterMicroButton:SetParent(JadeUIButtonParent)
    SpellbookMicroButton:SetParent(JadeUIButtonParent)
    if TalentMicroButton then
        TalentMicroButton:SetParent(JadeUIButtonParent)
    end
    QuestLogMicroButton:SetParent(JadeUIButtonParent)
    SocialsMicroButton:SetParent(JadeUIButtonParent)
    WorldMapMicroButton:SetParent(JadeUIButtonParent)
    MainMenuMicroButton:SetParent(JadeUIButtonParent)
    HelpMicroButton:SetParent(JadeUIButtonParent)
end


local function moveBagBar()
    --Bag Bar
    CharacterMicroButton:SetPoint("BOTTOMLEFT", JadeUI.g13MainBar, "BOTTOM", - 285, 2)
    MainMenuBarBackpackButton:SetParent(JadeUIButtonParent)
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", JadeUI.g13MainBar, "BOTTOM", 293, 2)

    for i = 0, 3 do
        _G["CharacterBag" .. i .. "Slot"]:SetParent(JadeUIButtonParent)
    end
end


local function moveActionBars()
    --Main Action Bar
    ActionButton1:ClearAllPoints()
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetParent(JadeUIButtonParent)
        _G["ActionButton" .. i]:SetFrameLevel(JadeUIBar:GetFrameLevel() + 1)
    end
    ActionButton1:SetPoint("CENTER", JadeUIBar, "CENTER", -127, 2)

    --Bottom Left Action Bar
    local _, multiRel = MultiBarBottomLeft:GetPoint()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", multiRel, "TOPLEFT", 0, 7)
    --MultiBarBottomLeft.SetPoint = function()end

    --Bottom Right Action Bar
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    MultiBarBottomRight:SetPoint("TOPLEFT", multiRel, "BOTTOMLEFT", 42, - 5)

    --Bottom Right Action Bar Second Row
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "BOTTOMLEFT", 0, - 5)

end


local function moveBlizzXPBar()
    --Exp Bar
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetParent(JadeUIBar)
    MainMenuExpBar:SetPoint("BOTTOM", JadeUI.g13MaxCover, "BOTTOM", 0, - 3)
    MainMenuExpBar:SetWidth(586)
    MainMenuExpBar:SetFrameStrata("BACKGROUND")

    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()
end


local function moveStanceBar()
    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetParent(JadeUIButtonParent)
    StanceBarFrame:SetPoint("BOTTOMLEFT", JadeUI.g13TopBar, "TOPLEFT", 133, - 120)
    --StanceBarFrame.SetPoint = function()end
end


local function movePetBar()
    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetParent(JadeUIButtonParent)
    PetActionBarFrame:SetScale(0.7)
    PetActionBarFrame:SetPoint("BOTTOMLEFT", JadeUI.g13TopBar, "TOPLEFT", 144, - 171)
    --PetActionBarFrame.SetPoint = function()end
end


local function hideButtons()
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


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    --if moveUnitFrames then
        moveUnitFramesFunc()
    --end

    --if moveMinimap then
        moveMinimapFunc()
    --end

    if JadeUI.isVanilla then
        moveTutorialFrame()
    end

    --minimapScaleFunc()
    moveCastingBar()
    moveFramerateLabel()
end

--Prevent Blizzard bars from moving
function JadeUI.preventActionBarMovement()
    UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["TutorialFrameParent"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["ExtraActionBarFrame"] = nil

    MainMenuBar:EnableMouse(false)
    MainMenuBar:UnregisterEvent("DISPLAY_SIZE_CHANGED")
    MainMenuBar:UnregisterEvent("UI_SCALE_CHANGED")

    local animations = {MainMenuBar.slideOut:GetAnimations()}
    animations[1]:SetOffset(0, 0)
end

--Move Blizzard Bars
function JadeUI.blizzBarMove()
    --Move Bars
    moveMicroMenu()
    moveBagBar()
    moveActionBars()
    hideButtons()

    if blizzXPBar then
        moveBlizzXPBar()
    end

    local forms = GetNumShapeshiftForms()
    if forms > 0 then
        moveStanceBar()
    end
    if UnitExists("pet") then
        movePetBar()
    end

    --Other Variables
    if stanceBarHide then
        StanceBarFrame:Hide()
    end
end


--Fix Bartender so the two bottom buttons go below the menu/bag
function JadeUI.bartenderFix()
    BT4Button54:SetFrameLevel(1)
    BT4Button58:SetFrameLevel(1)

    if stanceBarHide then
        BT4BarStanceBar:Hide()
    end
end







