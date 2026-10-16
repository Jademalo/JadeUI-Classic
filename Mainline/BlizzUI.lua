--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Functions
--------------------------------------------
--Calculate the width of the map to offset the bags. Pass as argument without () so the function itself is being passed and not the result 
local function bagOffset()
    return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())
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

	if self.hideBarArt or self.numRows > 2 or self.buttonPadding > self.minButtonPadding then
		return;
	end

	local dividersPool = self.isHorizontal and self.HorizontalDividersPool or self.VerticalDividersPool;
	local wasLastButtonShown = false;
	for i, actionButton in pairs(self.actionButtons) do
		if actionButton:IsShown() then
			if wasLastButtonShown and (actionButton ~= _G["MultiBarBottomRightButton"..math.ceil(self.numButtonsShowable/self.numRows)+1]) and (actionButton ~= _G["MultiBarBottomLeftButton"..math.ceil(self.numButtonsShowable/self.numRows)+1]) then --Specifically don't draw the divider if the next button is on the second level
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
--Functions to move Blizzard Action Bars
--------------------------------------------
local function containerOffset()
    local hookSet = false
    table.insert(JadeUI.hookTable, ContainerFrameContainer) --Add any frame with a hook to the table of hooked frames (This adds the pointer to the table, not a copy)
    ContainerFrameContainer.defaultPos = {ContainerFrameContainer:GetPoint()}

    hooksecurefunc(ContainerFrameContainer, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself

        if not JadeUIDB["moveMinimap"] then ContainerFrameContainer:SetAllPoints() return end --Rather than using the defaultPos like the other hooks, we use SetAllPoints to set both to UIParent

        hookSet = true
            ContainerFrameContainer:ClearAllPoints()
            ContainerFrameContainer:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
            ContainerFrameContainer:SetPoint("BOTTOMRIGHT", MinimapCluster, "BOTTOMLEFT", 0, 0)
        hookSet = false
    end)

    ContainerFrameContainer:SetPoint(ContainerFrameContainer:GetPoint()) --Fire SetPoint to fire the hook with the original frame data to prevent the hook from having bad data
end

--------------------------------------------
--Core functions to apply changes
--------------------------------------------
function JadeUI.SetupHooksForLayout()
    if not JadeUI.setupHooks then

        local function AddArt(frame)
            frame.UpdateDividers = UpdateDividers
            frame.enableDividers = true
            frame:UpdateDividers()
            BorderArt(frame)
        end

        AddArt(MultiBarBottomLeft)
        AddArt(MultiBarBottomRight)
        --AddArt(PetActionBar)

        if JadeUIDB["taintSafety"] < 1 then --Only on taintSafety 0
            --These have errors with taintLog 1, otherwise work fine unless you try to drag a button in combat
            if JadeUIDB["gameboardType"] == 0 then
                JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer1)
            end
            JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer5)
        end

        if JadeUIDB["taintSafety"] < 2 then --Only on taintSafety 0 and 1
            --Weirdly, if BottomManagedFrameContainer is disabled but RightManagedFrameContainer is not, then Right works fine
            --If taintLog 0 is set then they both also seems to work fine
            --Cast Bar, Extra Abilities, Encounter Bar, and Swing Timer are all part of BottomManagedFrameContainer
            JadeUI.MoveBlizzardFrame(BottomManagedFrameContainer, "BOTTOM", "TOP", 0, 47, MultiBarBottomLeft)
            --Boss Frames, Equipment Durability, and Objective Tracker are all part of RightManagedFrameContainer
            --This actively causes a taint failure in combat if Boss Frames are part of it, so they are always moved when moveMinimap is true
            JadeUI.MoveBlizzardFrame(RightManagedFrameContainer, "TOPRIGHT", "TOPLEFT", -5, 26, MultiBarLeft, "moveMinimap")
        end

        JadeUI.OffsetBlizzardFrame(ContainerFrameCombinedBags, bagOffset, 0, nil, "moveMinimap")
        containerOffset()

        JadeUI.HideBlizzardFrame(StoreMicroButton, "hideShop")

        JadeUI.setupHooks = true
    end
end