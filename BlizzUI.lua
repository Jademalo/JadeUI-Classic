--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
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


function JadeUI.MoveMinimapFunc()
    --Minimap
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("BOTTOMRIGHT", MinimapCluster:GetParent(), "BOTTOMRIGHT", 0, 0)
    MinimapCluster.SetPoint = function()end

    --Zone Text
    MinimapZoneTextButton:ClearAllPoints()
    MinimapZoneTextButton:SetPoint("CENTER", MinimapZoneTextButton:GetParent(), "CENTER", 0, -77)
    MinimapZoneTextButton.SetPoint = function()end

    --Minimap Toggle Button
    MinimapToggleButton:ClearAllPoints()
    MinimapToggleButton:SetPoint("CENTER", MinimapToggleButton:GetParent(), "BOTTOMRIGHT", -15, 19)
    MinimapToggleButton.SetPoint = function()end

    --Minimap Top Border
    MinimapBorderTop:ClearAllPoints()
    MinimapBorderTop:SetPoint("BOTTOMRIGHT", MinimapBorderTop:GetParent(), "BOTTOMRIGHT", 0, 0)
    MinimapBorderTop.SetPoint = function()end

    --Clock
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("CENTER", TimeManagerClockButton:GetParent(), "CENTER", 0, 75)
    TimeManagerClockButton.SetPoint = function()end

    --Buff Bar
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - 13, - 13)
    BuffFrame.SetPoint = function()end
end


function JadeUI.MinimapScaleFunc()
    --TODO: Rewrite this to make it a slider rather than a fixed amount
    if JadeUIDB.minimapScale then
        --if JadeUIDB.minimapScaleFactor ~= 1 then
            MinimapCluster:SetScale(JadeUIDB.minimapScaleFactor)

            if not moveMinimap then
                local buffOffset = (MinimapCluster:GetWidth() * JadeUIDB.minimapScaleFactor) + 8

                BuffFrame:ClearAllPoints()
                BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - buffOffset, - 13)
                BuffFrame.SetPoint = function()end
            end
        --end
    else
        MinimapCluster:SetScale(1)
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

local function microMenuHook()
    local spacing = 2
    CharacterMicroButton:SetParent(JadeUIButtonParent)
    CharacterMicroButton:SetPoint("BOTTOMLEFT", JadeUI.g13MainBar, "BOTTOM", - 288, 2)
    TalentMicroButton:SetParent(JadeUIButtonParent)
    if JadeUIDB.showTalents == true or (UnitLevel("player") >= SHOW_SPEC_LEVEL) then
        spacing = -2.5
        TalentMicroButton:Show()
        TalentMicroButton:SetPoint("BOTTOMLEFT", SpellbookMicroButton, "BOTTOMRIGHT", spacing, 0)
        QuestLogMicroButton:SetParent(JadeUIButtonParent)
        QuestLogMicroButton:SetPoint("BOTTOMLEFT", TalentMicroButton, "BOTTOMRIGHT", spacing, 0)
    else
        QuestLogMicroButton:SetParent(JadeUIButtonParent)
        QuestLogMicroButton:SetPoint("BOTTOMLEFT", SpellbookMicroButton, "BOTTOMRIGHT", spacing, 0)
    end
    SpellbookMicroButton:SetParent(JadeUIButtonParent)
    SpellbookMicroButton:SetPoint("BOTTOMLEFT", CharacterMicroButton, "BOTTOMRIGHT", spacing, 0)
    SocialsMicroButton:SetParent(JadeUIButtonParent)
    SocialsMicroButton:SetPoint("BOTTOMLEFT", QuestLogMicroButton, "BOTTOMRIGHT", spacing, 0)
    WorldMapMicroButton:SetParent(JadeUIButtonParent)
    WorldMapMicroButton:SetPoint("BOTTOMLEFT", SocialsMicroButton, "BOTTOMRIGHT", spacing, 0)
    MainMenuMicroButton:SetParent(JadeUIButtonParent)
    MainMenuMicroButton:SetPoint("BOTTOMLEFT", WorldMapMicroButton, "BOTTOMRIGHT", spacing, 0)
    HelpMicroButton:SetParent(JadeUIButtonParent)
    HelpMicroButton:SetPoint("BOTTOMLEFT", MainMenuMicroButton, "BOTTOMRIGHT", spacing, 0)
end



local function moveMicroMenu()

    hooksecurefunc("UpdateMicroButtons", microMenuHook)
    microMenuHook()

end


local function moveBagBar()
    --Bag Bar
    MainMenuBarBackpackButton:SetParent(JadeUIButtonParent)
    --MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", JadeUI.g13MainBar, "BOTTOM", 293, 2) --Accurate to actual bag bar
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", JadeUI.g13MainBar, "BOTTOM", 292, 3) --Better Fitting

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    KeyRingButton:SetParent(JadeUIButtonParent)
    --KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -5, -1) --Accurate to actual bag bar
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -5, -1) --Better fitting

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
    MainMenuExpBar:SetPoint("BOTTOM", JadeUI.g13XPBar, "BOTTOM", 0, - 3)
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
    if JadeUIDB.moveUnitFrames then
        JadeUI.moveUnitFramesFunc()
    end

    if JadeUIDB.moveMinimap then
        JadeUI.MoveMinimapFunc()
    end

    if JadeUI.isVanilla then
        moveTutorialFrame()
    end

    JadeUI.MinimapScaleFunc()
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








