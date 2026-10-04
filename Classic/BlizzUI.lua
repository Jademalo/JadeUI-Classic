--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Functions
--------------------------------------------
--Calculate the width of the map to offset the bags. Pass as argument without () so the function itself is being passed and not the result 
local function bagOffset()
    local barOffset = 0
    
    if MultiBarLeft:IsShown() and MultiBarRight:IsShown() then 
        barOffset = select(4, MultiBarLeft:GetPoint())+select(5, MultiBarLeft:GetPoint()) 
    elseif MultiBarLeft:IsShown() or MultiBarRight:IsShown() then
        barOffset = select(4, MultiBarRight:GetPoint())+select(5, MultiBarRight:GetPoint())
    end
    
    return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())-barOffset
end

--Calculate the width of the map to offset the tooltip.
local function tooltipOffset()
    return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale()) 
end

--Calculate the width of the map to offset the buffs, should be offset by 10 from minimap cluster. Pass as argument without () so the function itself is being passed and not the result 
local function buffOffset()
    local minimapWidth = MinimapCluster:GetWidth()*MinimapCluster:GetScale()
    if JadeUIDB.moveMinimap then
        return -10
    else
        return -(minimapWidth+10)
    end
end

--Calculate the height of the map to offset the quest frame, should be offset 27 from minimap cluster. Pass as argument without () so the function itself is being passed and not the result 
local function questOffset()
    local minimapExtraSize = MinimapCluster:GetHeight()-(MinimapCluster:GetHeight()*MinimapCluster:GetScale())
    if JadeUIDB.moveMinimap then
        return 0
    else
        return minimapExtraSize
    end
end

--Get a dynamic child object
function GetDynamicChildren(frame, child, index)
    index = index or 1

    local count = 0
    for _, children in ipairs({frame:GetChildren()}) do
        if children[child] then
            count = count + 1
            if count == index then
                return children[child]
            end
        end
    end
end

function GetIndexedChild(frame, index)
    local count = 0
    for _, child in ipairs({frame:GetRegions()}) do
        count = count + 1
        if count == index then
            return child
        end
    end
end

function GetIndexedRegion(frame, index)
    local count = 0
    for _, region in ipairs({frame:GetRegions()}) do
        count = count + 1
        if count == index then
            return region
        end
    end
end


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
    --Player Frame
    JadeUI.MoveBlizzardFrame(PlayerFrame, "BOTTOMLEFT", "TOPLEFT", 0, 0, JadeUIMainFrame, "moveUnitFrames")
    --Target Frame
    JadeUI.MoveBlizzardFrame(TargetFrame, "BOTTOMRIGHT", "TOPRIGHT", 0, 0, JadeUIMainFrame, "moveUnitFrames")

    if not JadeUI.isClassic then
        --Focus Frame
        JadeUI.MoveBlizzardFrame(FocusFrame, "BOTTOMLEFT", "BOTTOM", - 163, 250, nil, "moveUnitFrames")
    end
end

--Fixes for the vertical multi bars to have them properly react to the minimap's position
local function verticalMultiBarFix()
    --Fix error when map at the bottom by anchoring the top of right actionbars to BuffFrame instead (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MultiActionBars.lua#L60)
    local oldMinimapGetBottom = MinimapCluster.GetBottom
    function MinimapCluster:GetBottom()
        if oldMinimapGetBottom(self) < (UIParent:GetBottom() + (MinimapCluster:GetHeight()*MinimapCluster:GetScale())) then --If minimap get bottom is below the height of the minimap cluster off the bottom of UIParent
            return BuffFrame:GetBottom() --Return the bottom of the Buff Bar
        else
            return oldMinimapGetBottom(self)*self:GetScale() --GetBottom gives a position value relative to the scale domain of the minimap, rather than UIParent. We need to fix that.
        end
    end

    --Adjust the right action bars to bottom anchor to the minimap size when above it (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MultiActionBars.lua#L65)
    function MainMenuBarArtFrame:GetTop()
        if oldMinimapGetBottom(MinimapCluster) < (UIParent:GetBottom() + (MinimapCluster:GetHeight()*MinimapCluster:GetScale())) then
            return MinimapCluster:GetTop()*MinimapCluster:GetScale() --GetTop gives a position value relative to the scale domain of the minimap, rather than UIParent. We need to fix that since the minimap scale might not be 0.
        else
            return JadeUIBarTopArtFrame:GetTop()*JadeUIBarTopArtFrame:GetScale() --GetTop gives a position value relative to the scale domain of the frame, rather than UIParent. We need to fix that since the frame scale might not be 0. 
        end
    end
end

function JadeUI.MoveMinimapFunc()
    --Minimap
    JadeUI.MoveBlizzardFrame(MinimapCluster, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0, nil, "moveMinimap")
    --Minimap Zone Info
    JadeUI.MoveBlizzardFrame(MinimapCluster.BorderTop, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0, nil, "moveMinimap")
    JadeUI.MoveBlizzardFrame(MinimapCluster.MinimapContainer, "BOTTOM", "TOP", 0, 0, nil, "moveMinimap")
    --Clock
    JadeUI.MoveBlizzardFrame(TimeManagerClockButton, "CENTER", "CENTER", 0, 68, nil, "moveMinimap")

    --Bags
    for i = 1, 5 do JadeUI.OffsetBlizzardFrame(_G["ContainerFrame" .. i], bagOffset, 0, nil, "moveMinimap") end
    --Tooltip
    JadeUI.OffsetBlizzardFrame(GameTooltip, tooltipOffset, 0, nil, "moveMinimap")
    --Buff Bar
    JadeUI.MoveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", buffOffset, -13)
    --QuestWatchFrame
    JadeUI.OffsetBlizzardFrame(UIParentRightManagedFrameContainer, 0, questOffset)

    ActionBarController_UpdateAll() --This makes sure that the right hand bar gets repositioned after the minimap is moved around (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/ActionBarController.lua#L93)
end

function JadeUI.MinimapScaleFunc()
    MinimapCluster:SetScale(JadeUIDB.minimapScaleFactor)
    JadeUI.TriggerFrameHooks()
    ActionBarController_UpdateAll() --This makes sure that the right hand bar gets repositioned after the minimap is moved around (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/ActionBarController.lua#L93)
end

function JadeUI.ClockFlipFunc()
    hooksecurefunc(MinimapCluster, "SetPoint", function()
        if JadeUIDB.moveMinimap then
            GetIndexedRegion(TimeManagerClockButton, 1):SetTexCoord(0.015625, 0.8125, 0.390625, 0.015625)
        else
            GetIndexedRegion(TimeManagerClockButton, 1):SetTexCoord(0.015625, 0.8125, 0.015625, 0.390625)
        end
    end)
    JadeUI.TriggerFrameHooks()
end





--------------------------------------------
--Functions to move Blizzard Action Bars
--------------------------------------------
local function moveMicroMenu()
    --Micro Menu
    hooksecurefunc("UpdateMicroButtons", function()
        MicroMenuContainer:SetParent(JadeUIButtonParent)
        MicroMenuContainer:ClearAllPoints()
        MicroMenuContainer:SetPoint("BOTTOMLEFT", JadeUIMainFrame, "BOTTOM", -288, 2)

        if JadeUIDB.showTalents == true or C_SpecializationInfo.CanPlayerUseTalentSpecUI() then --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_MicroMenu/Classic/MainMenuBarMicroButtons.lua#L594
            TalentMicroButton:SetShown(JadeUIDB.showTalents or C_SpecializationInfo.CanPlayerUseTalentSpecUI())
            MicroMenu.childXPadding = -2.5
        else
            MicroMenu.childXPadding = 2
        end

        MicroMenu:Layout()
    end)

    UpdateMicroButtons()
end


local function moveBagBar()
    --Bag Bar
    BagsBar:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(BagsBar, "BOTTOMLEFT", "BOTTOM", 64, 3, JadeUIMainFrame)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    JadeUI.MoveBlizzardFrame(KeyRingButton, "RIGHT", "LEFT", -5, -1, CharacterBag3Slot) --Move keyring down 1 from default to better line it up with everything else
end


local function moveActionBars()

    local function SetButtonNum(frame, num)
        frame.numButtons = num
        frame.numButtonsShowable = num --This is set to numButtons on load, but needs to be set manually here - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L4
        frame:UpdateShownButtons() --This is necessary to run before changing the numRows because numRows uses shownButtonContainers - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L198 + https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L100
        frame:UpdateGridLayout()
    end
    -- Top Bar = 6
    -- Second Bar = 1
    -- Third Bar = 5 (1-5)
    -- Fourth Bar = 5 (7-9)

    --Forcibly enable bars 2 and 3
    --SetActionBarToggles(1, 1, 1, 1)
    --MultiActionBar_Update()

    --Main Action Bar
    JadeUI.MoveBlizzardFrame(MainActionBar, "CENTER", "CENTER", -1, 2, JadeUIMainFrame)
    MainActionBar:SetParent(JadeUIButtonParent)
    --Hide Bar Art
    MainActionBar:UpdateEndCaps(true) --https://github.com/Gethe/wow-ui-source/blob/8165d4cd6e48d606369336cc3a7977902310e81e/Interface/AddOns/Blizzard_ActionBar/Classic/MainActionBarOverrides.lua#L17
    MainActionBar.ActionBarPageNumber:Hide()
    SetButtonNum(MainActionBar, 7)

    --Bottom Left Action Bar
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(MultiBarBottomLeft, "BOTTOM", "TOP", 0, 6.5, MainActionBar)
    SetButtonNum(MultiBarBottomLeft, 7)

    --Bottom Right Action Bar
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(MultiBarBottomRight, "TOP", "BOTTOM", 0, -6.5, MainActionBar)
    SetButtonNum(MultiBarBottomRight, 10)
    MultiBarBottomRight.numRows = 2
    MultiBarBottomRight:UpdateGridLayout()
    JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer1)
    JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer5)

end

local function movePetBar()
    PetActionBar:SetParent(JadeUIButtonParent)
    PetActionBar:SetScale(0.7)
    JadeUI.MoveBlizzardFrame(PetActionBar, "BOTTOM", "TOP", -1.5, -41, JadeUIMainFrame)
    hooksecurefunc(PetActionBar, "SetBackgroundArtShown", function(self, shown) --Hook the show function to always force it to true
        if not shown then
            PetActionBar:SetBackgroundArtShown(true) --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua#L228
        end
    end)
    PetActionBar.BackgroundArt1:ClearAllPoints()
    PetActionBar.BackgroundArt1:SetPoint("TOPLEFT", PetActionBar, "TOPLEFT", -35, 10)
end

--Adapted from https://github.com/erikbrgn/AutoHideBinds/blob/main/AutoHideBinds.lua with permission
function JadeUI.HideKeybinds()
    local bars = {
        "Action",
        "MultiBarBottomLeft",
        "MultiBarBottomRight",
        "MultiBarRight",
        "MultiBarLeft",
        "MultiBar5",
        "MultiBar6",
        "MultiBar7"
    }
    for _, barName in ipairs(bars) do
        for buttonNumber = 1, 12 do
            local button = barName .. "Button" .. buttonNumber
            if _G[button] then
                _G[button .. "HotKey"]:Hide()
                _G[button .. "HotKey"].Show = function() end
            end
        end
    end
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    JadeUI.MoveBlizzardFrame(PlayerCastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    JadeUI.MoveBlizzardFrame(FramerateLabel, "BOTTOM", "BOTTOM", -190, 85) --Framerate
    JadeUI.MoveBlizzardFrame(DurabilityFrame, "LEFT", "RIGHT", 0, 23, JadeUIMainFrame) --Durability Frame

    --verticalMultiBarFix()
    JadeUI.moveUnitFramesFunc()
    JadeUI.MinimapScaleFunc() --Minimap Scale. Needs to be above Minimap since Minimap includes scale calcs.
    JadeUI.MoveMinimapFunc()
    JadeUI.ClockFlipFunc()

    if JadeUI.isClassic then 
        JadeUI.MoveBlizzardFrame(TutorialFrameParent,"BOTTOM", "BOTTOM", 0, 300) --Tutorial Frame
    end
end

--Move Blizzard Bars
function JadeUI.blizzBarMove()

    --Move Bars
    moveMicroMenu()
    moveBagBar()
    moveActionBars()
    if JadeUIDB.hideKeybinds then JadeUI.HideKeybinds() end

    local forms = GetNumShapeshiftForms()
    if forms > 0 then
        JadeUI.MoveBlizzardFrame(StanceBar, "BOTTOMLEFT", "TOP", -141.5, -27.5, JadeUIMainFrame)
    end
    movePetBar()

    --Other Variables
    if stanceBarHide then
        StanceBar:Hide()
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