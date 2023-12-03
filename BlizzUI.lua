--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...


--------------------------------------------
--Functions
--------------------------------------------
--Move an already set frame, then remove SetPoint so the UI can't set it back again
local function moveBlizzardFrame(frame, point, relativePoint, offsetX, offsetY)
    frame:ClearAllPoints()
    frame:SetPoint(point, frame:GetParent(), relativePoint, offsetX, offsetY)
    frame.SetPoint = function()end
end

--Hook for moving the tooltip. Needs to be hooked to GameTooltip:SetPoint
local gtHookSet = false
local function gtHook(self, motion) 

    if gtHookSet then return end --Don't infinitely fire from itself
    gtHookSet = true

    local point, relativeTo, relativePoint, offsetX, offsetY = GameTooltip:GetPoint()
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint(point, relativeTo, relativePoint, offsetX-(MinimapCluster:GetWidth()*MinimapCluster:GetEffectiveScale()), offsetY) --Make sure to get the actual scaled width of the minimap
    gtHookSet = false
end


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
    --Player Frame
    moveBlizzardFrame(PlayerFrame, "BOTTOMRIGHT", "BOTTOM", - 163, 200)
    --Target Frame
    moveBlizzardFrame(TargetFrame, "BOTTOMLEFT", "BOTTOM", 162, 200)

    if not JadeUI.isVanilla then
        --Focus Frame
        moveBlizzardFrame(FocusFrame, "BOTTOMLEFT", "BOTTOM", - 163, 250)
    end
end



function JadeUI.MoveMinimapFunc()
    --Minimap
    moveBlizzardFrame(MinimapCluster, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
    --Zone Text
    moveBlizzardFrame(MinimapZoneTextButton, "CENTER", "CENTER", 0, -77)
    --Minimap Toggle Button
    moveBlizzardFrame(MinimapToggleButton, "CENTER", "BOTTOMRIGHT", -15, 19)
    --Minimap Top Border
    moveBlizzardFrame(MinimapBorderTop, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
    --Clock
    moveBlizzardFrame(TimeManagerClockButton, "CENTER", "CENTER", 0, 75)
    --Buff Bar
    moveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", - 13, - 13)
    --Tooltip
    hooksecurefunc(GameTooltip, "SetPoint", gtHook)
    --Quest Watch Frame
    local _,_,_,_,buffQfix = BuffFrame:GetPoint()
    QuestWatchFrame:SetParent(BuffFrame)
    moveBlizzardFrame(QuestWatchFrame, "TOPRIGHT", "BOTTOMRIGHT", -84-buffQfix, 0)
end


function JadeUI.MinimapScaleFunc()
    --TODO: Rewrite this to make it a slider rather than a fixed amount
    if JadeUIDB.minimapScale then
        --if JadeUIDB.minimapScaleFactor ~= 1 then
            MinimapCluster:SetScale(JadeUIDB.minimapScaleFactor)

            if not JadeUIDB.moveMinimap then
                local buffOffset = (MinimapCluster:GetWidth() * JadeUIDB.minimapScaleFactor) + 8
                moveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", - buffOffset, - 13)
            end
        --end
    else
        MinimapCluster:SetScale(1)
    end
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
        _G["ActionButton" .. i]:SetFrameLevel(JadeUIButtonParent:GetFrameLevel() + 1)
    end
    ActionButton1:SetPoint("CENTER", JadeUIBar, "CENTER", -127, 2)

    --Bottom Left Action Bar
    local _, multiRel = MultiBarBottomLeft:GetPoint()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", multiRel, "TOPLEFT", 0, 7)
    MultiBarBottomLeft:SetFrameLevel(JadeUIButtonParent:GetFrameLevel() + 1)
    --MultiBarBottomLeft.SetPoint = function()end

    --Bottom Right Action Bar
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    MultiBarBottomRight:SetPoint("TOPLEFT", multiRel, "BOTTOMLEFT", 42, - 5)

    --Bottom Right Action Bar Second Row
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "BOTTOMLEFT", 0, - 7)

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
    moveBlizzardFrame(CastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    FramerateLabel:SetPoint("BOTTOM", FramerateLabel:GetParent(), "BOTTOM", - 190, 85) --Framerate Label

    if JadeUIDB.moveUnitFrames then JadeUI.moveUnitFramesFunc() end --Unit Frames
    if JadeUIDB.moveMinimap then JadeUI.MoveMinimapFunc() end --Minimap
    JadeUI.MinimapScaleFunc() --Minimap Scale

    if JadeUI.isVanilla then 
        moveBlizzardFrame(TutorialFrameParent,"BOTTOM", "BOTTOM", 0, 300) --Tutorial Frame
    end
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








