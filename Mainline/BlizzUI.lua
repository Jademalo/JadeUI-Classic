--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
STATUS_BAR_MANAGER_WIDTH = 772 --Override the base variable for status bar width - https://github.com/Gethe/wow-ui-source/blob/e3ecc27b64d30fdc735a3f6579b866858f9f9df1/Interface/AddOns/Blizzard_StatusTrackingBar/Shared/StatusTrackingManager.lua#L6

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
    for _, child in ipairs({frame:GetChildren()}) do
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

--Add UpdateDividers to frames that don't have it - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/MainActionBar.lua#L86
function UpdateDividers(self)
	if (not self.enableDividers) then
		return;
	end

	if not self.HorizontalDividersPool then
		self.HorizontalDividersPool = CreateFramePool("FRAME", self, "HorizontalDividerTemplate");
		self.VerticalDividersPool = CreateFramePool("FRAME", self, "VerticalDividerTemplate");
	end
	self.HorizontalDividersPool:ReleaseAll();
	self.VerticalDividersPool:ReleaseAll();

--[[ 	if self.hideBarArt or self.numRows > 1 or self.buttonPadding > self.minButtonPadding then
		return;
	end ]]

	local dividersPool = self.isHorizontal and self.HorizontalDividersPool or self.VerticalDividersPool;
	local wasLastButtonShown = false;
	for i, actionButton in pairs(self.actionButtons) do
		if actionButton:IsShown() then
			if wasLastButtonShown then
				local divider = dividersPool:Acquire();
				divider:ClearAllPoints();
				if self.isHorizontal then
					divider:SetPoint("TOP", actionButton, "TOP", 0, 0);
					divider:SetPoint("BOTTOM", actionButton, "BOTTOM", 0, 0);
					divider:SetPoint("RIGHT", actionButton, "LEFT", 5, 0);
				else
					divider:SetPoint("LEFT", actionButton, "LEFT", 0, 0);
					divider:SetPoint("RIGHT", actionButton, "RIGHT", 0, 0);
					divider:SetPoint("BOTTOM", actionButton, "TOP", 0, -5);
				end
				divider:Show();
			end
			wasLastButtonShown = true;
		else
			wasLastButtonShown = false;
		end
	end
end

--Add background to bar - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Mainline/MainActionBar.xml#L52
local function BorderArt(targetBar)

    local borderArt = targetBar:CreateTexture(nil, "BACKGROUND", nil, -3)
    borderArt:SetAtlas("UI-HUD-ActionBar-Frame", true)
    borderArt.ignoreInLayout = true

    borderArt:ClearAllPoints()
    borderArt:SetPoint("TOPLEFT", targetBar, "TOPLEFT", -6, 6)
    borderArt:SetPoint("BOTTOMRIGHT", targetBar, "BOTTOMRIGHT", 4, -5)

    targetBar.BorderArt = borderArt

    return borderArt
end


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
    --Player Frame
    JadeUI.MoveBlizzardFrame(PlayerFrame, "BOTTOMLEFT", "TOPLEFT", 0, 0, JadeUIMainFrame, "moveUnitFrames")
    --Target Frame
    JadeUI.MoveBlizzardFrame(TargetFrame, "BOTTOMRIGHT", "TOPRIGHT", 0, 0, JadeUIMainFrame, "moveUnitFrames")
    --Focus Frame
    JadeUI.MoveBlizzardFrame(FocusFrame, "BOTTOMLEFT", "BOTTOM", - 163, 250, nil, "moveUnitFrames")
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





--------------------------------------------
--Functions to move Blizzard Action Bars
--------------------------------------------
local function moveMicroMenu()
    --Micro Menu
    hooksecurefunc("UpdateMicroButtons", function()
        MicroMenuContainer:SetParent(JadeUIButtonParent)
        MicroMenuContainer:SetPoint("BOTTOMLEFT", JadeUIBar, "BOTTOMLEFT", 15, 5)

        --MicroMenu.childXPadding = 2

        MicroMenu:Layout()
    end)

    UpdateMicroButtons()
end


local function moveBagBar()
    --Bag Bar
    BagsBar:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(BagsBar, "BOTTOMRIGHT", "BOTTOMRIGHT", -5, 2, JadeUIBar)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    --JadeUI.MoveBlizzardFrame(KeyRingButton, "RIGHT", "LEFT", -5, -1, CharacterBag3Slot) --Move keyring down 1 from default to better line it up with everything else
end


local function moveActionBars()

    local function SetButtonNum(frame, num)
        frame.numButtons = num
        frame.numButtonsShowable = num --This is set to numButtons on load, but needs to be set manually here - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L4
        frame:UpdateShownButtons() --This is necessary to run before changing the numRows because numRows uses shownButtonContainers - https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L198 + https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua#L100
        frame:UpdateGridLayout()
    end

    local function AddBorderArt(frame)
        frame.UpdateDividers = UpdateDividers
        frame.enableDividers = true
        frame:UpdateDividers()
        BorderArt(frame)
    end
    -- Top Bar = 6
    -- Second Bar = 1
    -- Third Bar = 5 (1-5)
    -- Fourth Bar = 5 (7-9)

    --Forcibly enable bars 2 and 3
    --SetActionBarToggles(1, 1, 1, 1)
    --MultiActionBar_Update()

    --Main Action Bar
    JadeUI.MoveBlizzardFrame(MainActionBar, "BOTTOM", "CENTER", 0, -11.5, JadeUIBar)
    MainActionBar:SetParent(JadeUIButtonParent)
    --Hide Bar Art
    --MainActionBar:UpdateEndCaps(true) --https://github.com/Gethe/wow-ui-source/blob/8165d4cd6e48d606369336cc3a7977902310e81e/Interface/AddOns/Blizzard_ActionBar/Classic/MainActionBarOverrides.lua#L17
    MainActionBar.ActionBarPageNumber:Hide()
    SetButtonNum(MainActionBar, 7)
    JadeUI.MoveBlizzardFrame(MainActionBar.EndCaps.LeftEndCap, "BOTTOMRIGHT", "BOTTOMLEFT", 28, -7, MicroMenu)

    --Bottom Left Action Bar
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(MultiBarBottomLeft, "BOTTOMLEFT", "TOPLEFT", 0, -1, MainActionBar) --6 for large gap
    SetButtonNum(MultiBarBottomLeft, 7)
    AddBorderArt(MultiBarBottomLeft)


    --Bottom Right Action Bar
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    JadeUI.MoveBlizzardFrame(MultiBarBottomRight, "TOP", "BOTTOM", 0, 1, MainActionBar) --6 for large gap
    SetButtonNum(MultiBarBottomRight, 10)
    MultiBarBottomRight.numRows = 2
    MultiBarBottomRight:UpdateGridLayout()
    JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer1)
    JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer5)
    AddBorderArt(MultiBarBottomRight)
    JadeUI.HideBlizzardFrame(GetIndexedChild(MultiBarBottomRight, 18)) --18 is necessary to target the left hand divider since it is the 18th child created



end

local function movePetBar()
    PetActionBar:SetParent(JadeUIButtonParent)
    PetActionBar:SetScale(0.7)
    JadeUI.MoveBlizzardFrame(PetActionBar, "BOTTOM", "TOP", 1.5, 1.5, JadeUIBar)
    hooksecurefunc(PetActionBar, "SetBackgroundArtShown", function(self, shown) --Hook the show function to always force it to true
        if not shown then
            PetActionBar:SetBackgroundArtShown(true) --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua#L228
        end
    end)
    --PetActionBar.BackgroundArt1:ClearAllPoints()
    --PetActionBar.BackgroundArt1:SetPoint("TOPLEFT", PetActionBar, "TOPLEFT", -35, 10)
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

local function moveStatusBars()

    local function setOverlayStrataHigh(frame)
        for _, children in ipairs({frame:GetChildren()}) do
            if children["OverlayFrame"] then
                children["OverlayFrame"]:SetFrameStrata("HIGH")
            end
        end
    end

    --This is a trigger function to set the action bar positions depending on whether or not a faction is being watched
    local hookSet = false --Don't trigger on itself
    local function isTracking()
        if hookSet then return end
        hookSet = true
        if C_Reputation.GetWatchedFactionData() == nil then
            MainStatusTrackingBarContainer:ClearAllPoints()
            MainStatusTrackingBarContainer:SetPoint("BOTTOMLEFT", MicroMenu, "TOPLEFT", -2, 6)
        else
            SecondaryStatusTrackingBarContainer:ClearAllPoints()
            SecondaryStatusTrackingBarContainer:SetPoint("BOTTOMLEFT", MicroMenu, "TOPLEFT", -2, 6)
            MainStatusTrackingBarContainer:ClearAllPoints()
            MainStatusTrackingBarContainer:SetPoint("BOTTOMLEFT", SecondaryStatusTrackingBarContainer, "TOPLEFT", 0, -1)
        end
        hookSet = false
    end

    hooksecurefunc(MainStatusTrackingBarContainer, "SetPoint", isTracking)

    MainStatusTrackingBarContainer:ClearFrameSnap()
    SecondaryStatusTrackingBarContainer:ClearFrameSnap()

    --This fires on the end of the status bar animation, once on the fade out and once on the fade in
    MainStatusTrackingBarContainer:SubscribeToOnFinishedAnimating(MainStatusTrackingBarContainer, isTracking)

    setOverlayStrataHigh(MainStatusTrackingBarContainer)
    setOverlayStrataHigh(SecondaryStatusTrackingBarContainer)
end

--------------------------------------------
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    JadeUI.MoveBlizzardFrame(PlayerCastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    JadeUI.MoveBlizzardFrame(FramerateFrame, "BOTTOM", "BOTTOM", -190, 85) --Framerate
    --JadeUI.MoveBlizzardFrame(DurabilityFrame, "LEFT", "RIGHT", 0, 23, JadeUIBarTopArtFrame) --Durability Frame

    --verticalMultiBarFix()
    JadeUI.moveUnitFramesFunc()
    --JadeUI.MinimapScaleFunc() --Minimap Scale. Needs to be above Minimap since Minimap includes scale calcs.
    --JadeUI.MoveMinimapFunc()
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
        JadeUI.MoveBlizzardFrame(StanceBar, "BOTTOMLEFT", "TOPLEFT", 15, 2.5, JadeUIBar)
    end
    movePetBar()
    moveStatusBars()

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