--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

--------------------------------------------
--Functions
--------------------------------------------
--Calculate the width of the map to offset the bags and tooltip. Pass as argument without () so the function itself is being passed and not the result 
local function mapOffset()
    return -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())-10
end

local function talentButtonToggle()
    --Micro Menu
    hooksecurefunc("UpdateMicroButtons", function()

        if JadeUIDB.showTalents == true or C_SpecializationInfo.CanPlayerUseTalentSpecUI() then --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_MicroMenu/Classic/MainMenuBarMicroButtons.lua#L594
            TalentMicroButton:SetShown(JadeUIDB.showTalents or C_SpecializationInfo.CanPlayerUseTalentSpecUI())
            MicroMenu.childXPadding = -2.5
        else
            MicroMenu.childXPadding = 1.9
        end

        MicroMenuContainer:Layout()
    end)

    UpdateMicroButtons()
end

--------------------------------------------
--Status Bars
--------------------------------------------
--Hide the art for the main status bar - https://github.com/Gethe/wow-ui-source/blob/8165d4cd6e48d606369336cc3a7977902310e81e/Interface/AddOns/Blizzard_ActionBar/Classic/StatusTrackingManagerOverrides.lua#L64
local function UseMainMenuBarArt(self, useMainMenuBarArt)
	for index, texture in ipairs(self.MainMenuBarTextures) do
		texture:SetShown(false);
	end
	for index, texture in ipairs(self.StandaloneTextures) do
		texture:SetShown(false);
	end
end

local function resizeStatusBar(bar, width, height)
    bar:SetWidth(width)
    bar:SetHeight(height)
    if bar:GetShownBar() then bar:GetShownBar():SetShown(false) end --Hide the previously initalised bar
    bar:InitializeBars()
    bar:SetShownBar(bar:GetShownBar()) --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/StatusTrackingManager.lua#L185
end

local function replaceBlizzExpBarTexture()
    MainStatusTrackingBarContainer.UseMainMenuBarArt = UseMainMenuBarArt
    MainStatusTrackingBarContainer:UseMainMenuBarArt()
    JadeUIExpBarCover = JadeUIBar:CreateTexture("JadeUIExpBarCover")
    JadeUIExpBarCover:SetPoint("BOTTOM", MainStatusTrackingBarContainer, "BOTTOM", 0, 2)
    JadeUIExpBarCover:SetTexture(JadeUI.textures.g13ExpBarTexture)
    JadeUIExpBarCover:SetDrawLayer("BORDER", 7)
    JadeUIExpBarCover:SetParent(MainStatusTrackingBarContainer)
    JadeUIExpBarCover:SetScale(1 / StatusTrackingBarManager.ClassicScale)
end

local function replaceBlizzRepBarTexture()
    SecondaryStatusTrackingBarContainer.UseMainMenuBarArt = UseMainMenuBarArt
    SecondaryStatusTrackingBarContainer:UseMainMenuBarArt()
    JadeUIRepBarCover = JadeUIBar:CreateTexture("JadeUIRepBarCover")
    JadeUIRepBarCover:SetPoint("BOTTOM", SecondaryStatusTrackingBarContainer, "BOTTOM", 0, 0)
    JadeUIRepBarCover:SetTexture(JadeUI.textures.g13RepBarTexture)
    JadeUIRepBarCover:SetDrawLayer("BORDER", 7)
    JadeUIRepBarCover:SetParent(SecondaryStatusTrackingBarContainer)
    JadeUIRepBarCover:SetScale(1 / StatusTrackingBarManager.ClassicScale)
end

local function createMaxLevelCover()
        JadeUIMaxLevelCover = JadeUIBar:CreateTexture("JadeUIMaxLevelCover")
        JadeUIMaxLevelCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
        JadeUIMaxLevelCover:SetTexture(JadeUI.textures.g13MaxCoverTexture)
        JadeUIMaxLevelCover:SetDrawLayer("BACKGROUND", -1)
end

function JadeUI.showMaxCover()
    if not JadeUIMaxLevelCover then createMaxLevelCover() end
    if MainStatusTrackingBarContainer:GetShownBar() == nil then
        JadeUIMaxLevelCover:Show()
    else
        JadeUIMaxLevelCover:Hide()
    end
 end

--------------------------------------------
--Core functions to apply changes
--------------------------------------------
function JadeUI.SetupHooksForLayout()
    if not JadeUI.setupHooks then

        if JadeUIDB["taintSafety"] < 1 then --Only on taintSafety 0
            --These have errors with taintLog 1, otherwise work fine unless you try to drag a button in combat
            JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer1)
            JadeUI.HideBlizzardFrame(MultiBarBottomRightButtonContainer5)
        end

        if JadeUIDB["taintSafety"] < 2 then --Only on taintSafety 0 and 1
            --Weirdly, if BottomManagedFrameContainer is disabled but RightManagedFrameContainer is not, then Right works fine
            --If taintLog 0 is set then they both also seems to work fine
            --Cast Bar, Extra Abilities, Encounter Bar, and Swing Timer are all part of BottomManagedFrameContainer
            JadeUI.MoveBlizzardFrame(UIParentBottomManagedFrameContainer, "BOTTOM", "TOP", 0, 47, MultiBarBottomLeft)
            --Boss Frames, Equipment Durability, and Objective Tracker are all part of RightManagedFrameContainer
            --This actively causes a taint failure in combat if Boss Frames are part of it, so they are always moved when moveMinimap is true
            JadeUI.MoveBlizzardFrame(UIParentRightManagedFrameContainer, "TOPRIGHT", "TOPLEFT", -5, 26, MultiBarLeft, "moveMinimap")
        end

        replaceBlizzExpBarTexture()
        resizeStatusBar(MainStatusTrackingBarContainer, 598, 11)
        replaceBlizzRepBarTexture()
        resizeStatusBar(SecondaryStatusTrackingBarContainer, 598, 8)

        talentButtonToggle()

        hooksecurefunc(PetActionBar, "SetBackgroundArtShown", function(self, shown) --Hook the show function to always force it to true
            if not shown then
                PetActionBar:SetBackgroundArtShown(true) --https://github.com/Gethe/wow-ui-source/blob/09b9db7948abc9b9648dedaab51eb0cf3ee67b31/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua#L228
            end
        end)
        PetActionBar:SetBackgroundArtShown(true)
        PetActionBar.BackgroundArt1:SetScale(PetActionBarButtonContainer1:GetScale())
        PetActionBar.BackgroundArt2:SetScale(PetActionBarButtonContainer1:GetScale())

        --Bags
        for i = 1, 5 do JadeUI.OffsetBlizzardFrame(_G["ContainerFrame" .. i], mapOffset, 0, nil, "moveMinimap") end
        --Tooltip
        JadeUI.OffsetBlizzardFrame(GameTooltip, mapOffset, 0, nil, "moveMinimap")

        hooksecurefunc(StatusTrackingBarManager, "UpdateBarVisuals", function(self, shown) JadeUI.showMaxCover() end)

        JadeUI.createArtFrame() --Create the main art frame for the bars
        JadeUI.setEndstop(JadeUIDB.endstopType) --Set the endstop type based on the saved variable

        JadeUI.setupHooks = true
    end
end