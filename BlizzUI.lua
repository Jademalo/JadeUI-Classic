--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
local hookTable = {}

--------------------------------------------
--Functions
--------------------------------------------
--If the passed variable is a function calculate it, else return the variable.
local function calcFunction(var)
    if type(var) == "function" then --Calculate functions for the offsets if we're being passed one
        return var()
    else
        return var
    end
end

--Trigger the hook for every frame by running SetPoint with their default position
function JadeUI.TriggerFrameHooks()
    for _, frame in pairs(hookTable) do
        frame:ClearAllPoints()
        frame:SetPoint(SafeUnpack(frame.defaultPos))
    end
end

--Calculate the width of the map to offset the tooltip and bags. Pass as argument without () so the function itself is being passed and not the result 
local function minimapWidthOffset()
    local barOffset = 0
    
    if MultiBarLeft:IsShown() and MultiBarRight:IsShown() then 
        barOffset = select(4, MultiBarLeft:GetPoint())+select(5, MultiBarLeft:GetPoint()) 
    elseif MultiBarLeft:IsShown() or MultiBarRight:IsShown() then
        barOffset = select(4, MultiBarRight:GetPoint())+select(5, MultiBarRight:GetPoint())
    end
    
    return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())-barOffset
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
--Hooks
--------------------------------------------
--Move a frame by hooking its SetPoint and overriding it's position every time it tries to move
local function moveBlizzardFrame(frame, setPoint, setRelativePoint, setOffsetX, setOffsetY, setRelativeTo, savedVar)
    local hookSet = false
    table.insert(hookTable, frame) --Add any frame with a hook to the table of hooked frames (This adds the pointer to the table, not a copy)
    frame.defaultPos = {frame:GetPoint()} --Get the default position of the frame before the hook started to mess with things

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself

        if savedVar then
            if not JadeUIDB[savedVar] then return end
        end

        hookSet = true
            --local _,oldAnchor = frame:GetPoint()
            setRelativeTo = setRelativeTo or frame.defaultPos[2] --relativeTo is either the existing point or an arg if set manually

            frame:ClearAllPoints()
            frame:SetPoint(setPoint, setRelativeTo, setRelativePoint, calcFunction(setOffsetX), calcFunction(setOffsetY)) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)

    frame:SetPoint(frame:GetPoint()) --Fire SetPoint to fire the hook with the original frame data to prevent the hook from having bad data
end

--Offset a frame by hooking its SetPoint and adding the offset to its position
local function offsetBlizzardFrame(frame, setOffsetX, setOffsetY, setRelativeTo, savedVar)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself
        if savedVar then
            if not JadeUIDB[savedVar] then return end
        end

        local basePos = {frame:GetPoint()} --Back up the current position of the frame
        if (basePos[2] ~= UIParent) and (not setRelativeTo) then return end --Hacky fix for item tooltips and secondary bags being offset, while letting quest frame still move. Needs improvement.

        local offsetXCalc = basePos[4]+calcFunction(setOffsetX)
        local offsetYCalc = basePos[5]+calcFunction(setOffsetY)
        local setRelativeToOut = setRelativeTo or basePos[2] --If no new parent is defined, use the old one. Use a new variable so as not to pollute setRelativeTo and have subsequent runs of the hook get stuck on the first relative used

        hookSet = true
            frame:ClearAllPoints()
            frame:SetPoint(basePos[1], setRelativeToOut, basePos[3], offsetXCalc, offsetYCalc) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)
end

--Forcibly hide a frame by hooking Show and forcing it to hide whenever it tries
local function hideBlizzardFrame(frame)
    hooksecurefunc(frame,"Show", function() frame:Hide() end)
    frame:Hide()
end


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
    --Player Frame
    moveBlizzardFrame(PlayerFrame, "BOTTOMLEFT", "TOPLEFT", 0, 0, JadeUIMainFrame, "moveUnitFrames")
    --Target Frame
    moveBlizzardFrame(TargetFrame, "BOTTOMRIGHT", "TOPRIGHT", 0, 0, JadeUIMainFrame, "moveUnitFrames")

    if not JadeUI.isVanilla then
        --Focus Frame
        moveBlizzardFrame(FocusFrame, "BOTTOMLEFT", "BOTTOM", - 163, 250, nil, "moveUnitFrames")
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
    moveBlizzardFrame(MinimapCluster, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0, nil, "moveMinimap")
    --Minimap Zone Info
    moveBlizzardFrame(MinimapCluster.BorderTop, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0, nil, "moveMinimap")
    moveBlizzardFrame(MinimapCluster.MinimapContainer, "BOTTOM", "TOP", 0, 0, nil, "moveMinimap")
    --Clock
    moveBlizzardFrame(TimeManagerClockButton, "CENTER", "CENTER", 0, 68, nil, "moveMinimap")
    --Quest Watch Frame
    offsetBlizzardFrame(QuestWatchFrame, 0, 0, BuffFrame, "moveMinimap")

    --Bags
    for i = 1, 5 do offsetBlizzardFrame(_G["ContainerFrame" .. i], minimapWidthOffset, 0, nil, "moveMinimap") end
    --Tooltip
    offsetBlizzardFrame(GameTooltip, (function() return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale()) end), 0, nil, "moveMinimap")

    --Buff Bar, should be offset by 10 from minimap cluster
    local function buffOffset()
        local minimapWidth = MinimapCluster:GetWidth()*MinimapCluster:GetScale()
        if JadeUIDB.moveMinimap then
            return -10
        else
            return -(minimapWidth+10)
        end
    end
    moveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", buffOffset, -13)

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
        MicroMenuContainer:SetPoint("BOTTOMLEFT", JadeUIBarArtFrame, "BOTTOMLEFT", 11, 2)

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
    moveBlizzardFrame(BagsBar, "BOTTOMRIGHT", "BOTTOMRIGHT", -7, 3, JadeUIBarArtFrame)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    moveBlizzardFrame(KeyRingButton, "RIGHT", "LEFT", -5, -1, CharacterBag3Slot) --Move keyring down 1 from default to better line it up with everything else
end


local function moveActionBars()

    local function SetButtonNum(frame, num)
        frame.numButtons = num
        frame.numButtonsShowable = num --This is set to numButtons on load, but needs to be set manually here - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L4
        frame:UpdateShownButtons() --This is necessary to run before changing the numRows because numRows uses shownButtonContainers - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L198 + https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L100
    end
    -- Top Bar = 6
    -- Second Bar = 1
    -- Third Bar = 5 (1-5)
    -- Fourth Bar = 5 (7-9)

    --Forcibly enable bars 2 and 3
    --SetActionBarToggles(1, 1, 1, 1)
    --MultiActionBar_Update()

    --Main Action Bar
    moveBlizzardFrame(MainActionBar, "LEFT", "LEFT", 11.5, -4.5, JadeUIBarTopArtFrame)
    MainActionBar:SetParent(JadeUIButtonParent)
    --Hide Bar Art
    MainActionBar:UpdateEndCaps(true) --https://github.com/Gethe/wow-ui-source/blob/8165d4cd6e48d606369336cc3a7977902310e81e/Interface/AddOns/Blizzard_ActionBar/Classic/MainActionBarOverrides.lua#L17
    MainActionBar.ActionBarPageNumber:Hide()
    SetButtonNum(MainActionBar, 7)

    --Bottom Left Action Bar
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomLeft, "BOTTOMLEFT", "TOPLEFT", 0, 6.5, MainActionBar)
    SetButtonNum(MultiBarBottomLeft, 7)

    --Bottom Right Action Bar
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomRight, "TOPLEFT", "BOTTOMLEFT", 42, -6.5, MainActionBar)
    SetButtonNum(MultiBarBottomRight, 10)
    MultiBarBottomRight.numRows = 2
    MultiBarBottomRight:UpdateGridLayout()

end

local function movePetBar()
    PetActionBar:SetParent(JadeUIButtonParent)
    PetActionBar:SetScale(0.7)
    moveBlizzardFrame(PetActionBar, "BOTTOM", "TOP", 1.5, 1.5, JadeUIBarTopArtFrame)
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
    moveBlizzardFrame(PlayerCastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    moveBlizzardFrame(FramerateLabel, "BOTTOM", "BOTTOM", -190, 85) --Framerate
    moveBlizzardFrame(DurabilityFrame, "LEFT", "RIGHT", 0, 23, JadeUIBarTopArtFrame) --Durability Frame

    --verticalMultiBarFix()
    JadeUI.moveUnitFramesFunc()
    JadeUI.MinimapScaleFunc() --Minimap Scale. Needs to be above Minimap since Minimap includes scale calcs.
    JadeUI.MoveMinimapFunc()
    JadeUI.ClockFlipFunc()

    if JadeUI.isVanilla then 
        moveBlizzardFrame(TutorialFrameParent,"BOTTOM", "BOTTOM", 0, 300) --Tutorial Frame
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
        moveBlizzardFrame(StanceBar, "BOTTOMLEFT", "TOPLEFT", 15, 2.5, JadeUIBarTopArtFrame)
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