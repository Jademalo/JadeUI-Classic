--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...


--------------------------------------------
--Functions
--------------------------------------------
--Move a frame by hooking its SetPoint and overriding it's position every time it tries to move
local function moveBlizzardFrame(frame, point, relativePoint, offsetX, offsetY, relativeTo)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself
        hookSet = true
            local _,oldAnchor = frame:GetPoint()
            relativeTo = relativeTo or oldAnchor --relativeTo is either the existing point or an arg if set manually
            print(frame:GetName()," = ",oldAnchor:GetName())
            frame:ClearAllPoints()
            frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)

    frame:SetPoint(frame:GetPoint()) --Fire SetPoint to fire the hook with the original frame data to prevent the hook from having bad data
end

--Offset a frame by hooking its SetPoint and adding the offset to its position
local function offsetBlizzardFrame(frame, offsetX, offsetY)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself

        if frame == GameTooltip then --Hacky fix for item tooltips being offset
            local _,gtPoint = GameTooltip:GetPoint()
            if gtPoint ~= UIParent then return end
        end
    
        local oldPos = {frame:GetPoint()} --Back up the current position of the frame
        local offsetCalcX = oldPos[4]+offsetX
        local offsetCalcY = oldPos[5]+offsetY

        hookSet = true
            frame:ClearAllPoints()
            frame:SetPoint(oldPos[1], oldPos[2], oldPos[3], offsetCalcX, offsetCalcY) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)
end

--Forcibly hide a frame by hooking Show and forcing it to hide whenever it tries
local function hideBlizzardFrame(frame)
    hooksecurefunc(frame,"Show", function() frame:Hide() end)
    frame:Hide()
end

--[[ --Hook UIParent_ManageFramePosition to allow for additional overrides
local origUIParent_ManageFramePosition = UIParent_ManageFramePosition
UIParent_ManageFramePosition = function(index, value, yOffsetFrames, xOffsetFrames, hasBottomLeft, hasBottomRight, hasPetBar)

    origUIParent_ManageFramePosition(index, value, yOffsetFrames, xOffsetFrames, hasBottomLeft, hasBottomRight, hasPetBar)

end ]]


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
    moveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", - 13, - 13, UIParent)
    --Quest Watch Frame
    local _,_,_,_,buffQfix = BuffFrame:GetPoint()
    QuestWatchFrame:SetParent(BuffFrame)
    moveBlizzardFrame(QuestWatchFrame, "TOPRIGHT", "BOTTOMRIGHT", -84-buffQfix, 0, BuffFrame)
    --Bags
    offsetBlizzardFrame(ContainerFrame1, -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())+VerticalMultiBarsContainer:GetWidth(), 0)
    --Tooltip
    offsetBlizzardFrame(GameTooltip, -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())+VerticalMultiBarsContainer:GetWidth(), 0)

    --Fix error when map is below right action bars
    local oldGetBottom = MinimapCluster.GetBottom
    function MinimapCluster:GetBottom()
        print(oldGetBottom(self))
        if oldGetBottom(self) < (UIParent:GetBottom() + MinimapCluster:GetHeight()) then
            return BuffFrame:GetBottom()
        else
            return oldGetBottom(self)
        end
    end

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
    moveBlizzardFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", "BOTTOM", 292, 3, JadeUI.g13MainBar) --Better Fitting

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    KeyRingButton:SetParent(JadeUIButtonParent)
    --KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -5, -1) --Accurate to actual bag bar
    moveBlizzardFrame(KeyRingButton, "RIGHT", "LEFT", -5, -1, CharacterBag3Slot) --Better Fitting

    for i = 0, 3 do
        _G["CharacterBag" .. i .. "Slot"]:SetParent(JadeUIButtonParent)
    end

end


local function moveActionBars()
    --Main Action Bar
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetParent(JadeUIButtonParent)
        _G["ActionButton" .. i]:SetFrameLevel(JadeUIButtonParent:GetFrameLevel() + 1)
    end
    moveBlizzardFrame(ActionButton1, "CENTER", "CENTER", -127, 2, JadeUIBar)

    --Bottom Left Action Bar
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomLeft, "BOTTOMLEFT", "TOPLEFT", 0, 7)

    --Bottom Right Action Bar
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomRight, "TOPLEFT", "BOTTOMLEFT", 42, -47)

    --Bottom Right Action Bar Second Row
    moveBlizzardFrame(MultiBarBottomRightButton7, "TOPLEFT", "BOTTOMLEFT", 0, -7, MultiBarBottomRightButton1)

end

local function movePetBar()
    PetActionBarFrame:SetParent(JadeUIButtonParent)
    PetActionBarFrame:SetScale(0.7)
    moveBlizzardFrame(PetActionBarFrame, "BOTTOM", "TOP", 33, -44, JadeUIBarTopArtPanel)
end

local function hideButtons()
    --Main Action Bar
    for i = 8, 12 do
        hideBlizzardFrame(_G["ActionButton" .. i])
        hideBlizzardFrame(_G["MultiBarBottomLeftButton" .. i])
    end

    --Bottom Right Action Bar
    hideBlizzardFrame(MultiBarBottomRightButton6)
    hideBlizzardFrame(MultiBarBottomRightButton7)
    hideBlizzardFrame(MultiBarBottomRightButton11)
    hideBlizzardFrame(MultiBarBottomRightButton12)
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    moveBlizzardFrame(CastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    moveBlizzardFrame(FramerateLabel, "BOTTOM", "BOTTOM", -190, 85) --Framerate
    moveBlizzardFrame(DurabilityFrame, "LEFT", "RIGHT", 0, 23, JadeUIBarTopArtPanel) --Durability Frame

    if JadeUIDB.moveUnitFrames then JadeUI.moveUnitFramesFunc() end --Unit Frames/ff
    JadeUI.MinimapScaleFunc() --Minimap Scale. Needs to be above Minimap since Minimap includes scale calcs.
    if JadeUIDB.moveMinimap then JadeUI.MoveMinimapFunc() end --Minimap


    if JadeUI.isVanilla then 
        moveBlizzardFrame(TutorialFrameParent,"BOTTOM", "BOTTOM", 0, 300) --Tutorial Frame
    end
end

--Prevent Blizzard bars from moving
function JadeUI.preventActionBarMovement()
    UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil --Definitely does something, not sure what
    UIPARENT_MANAGED_FRAME_POSITIONS["TutorialFrameParent"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
    UIPARENT_MANAGED_FRAME_POSITIONS["ExtraActionBarFrame"] = nil
end

--Move Blizzard Bars
function JadeUI.blizzBarMove()
    --Move Bars
    moveMicroMenu()
    moveBagBar()
    moveActionBars()
    hideButtons()
    hideBlizzardFrame(MainMenuBar)

    local forms = GetNumShapeshiftForms()
    if forms > 0 then
        moveBlizzardFrame(StanceBarFrame, "BOTTOMLEFT", "TOPLEFT", 133, -120, JadeUIBarTopArtPanel)
    end
    movePetBar()

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








