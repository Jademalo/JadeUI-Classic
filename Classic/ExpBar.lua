--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
local textures = JadeUI.textures
JadeUI.expBar = {}
local expBar = JadeUI.expBar

--Get specific elements of the exp and rep bars
local statusBars = {
    exp = {},
    rep = {},
}
statusBars.exp.StatusBar = GetDynamicChildren(MainStatusTrackingBarContainer, "StatusBar", 2)
statusBars.exp.OverlayFrame = GetDynamicChildren(MainStatusTrackingBarContainer, "OverlayFrame", 2)
statusBars.exp.ExhaustionLevelFillBar = GetDynamicChildren(MainStatusTrackingBarContainer, "ExhaustionLevelFillBar")
statusBars.exp.ExhaustionTick = GetDynamicChildren(MainStatusTrackingBarContainer, "ExhaustionTick")
statusBars.exp.RepStatusBar = GetDynamicChildren(MainStatusTrackingBarContainer, "StatusBar")
statusBars.exp.RepOverlayFrame = GetDynamicChildren(MainStatusTrackingBarContainer, "OverlayFrame")
statusBars.rep.StatusBar = GetDynamicChildren(SecondaryStatusTrackingBarContainer, "StatusBar")
statusBars.rep.OverlayFrame = GetDynamicChildren(SecondaryStatusTrackingBarContainer, "OverlayFrame")
statusBars.Offset = 1 --This controls how big the rep and xp bars are relative to eachother



--------------------------------------------
--Functions to handle strata changes on mouseover
--------------------------------------------
--[[ MEDIUM
    Level 13    - MultiBarBottomLeftButtons
    Level 12    - ActionButtons + MultiBarBottomLeft
    Level 11    - JadeUIButtonParent
    Level 10    - ExhaustionTick
    Level 9     - MultiBarBottomRightButton8/9/10
    Level 8     - JadeUIBarArtFrame                                         - Must be on top of the Exp bar
    Level 7     - MainMenuExpBar                                            - Must be on top of the Rep bar
    Level 6     - ReputationWatchBar (Active)
    Level 5     - MultiBarBottomRightButtons
    Level 4     - MultiBarBottomRight
    Level 3     - JadeUIBarTopArtFrame
    Level 2     - ReputationWatchBar (Inactive)
    Level 1     - JadeUIBar (Invisible parent)
    Level 0     - UIParent

    LOW
    Level 4     - SecondaryStatusTrackingBarContainer.<dynamic>.StatusBar
    Level 3     - MainStatusTrackingBarContainer.<dynamic>.StatusBar        - Must be below the Rep bar
    Level 2     - JadeUITopArtFrame                                         - Must be below XP bar when on LOW
 ]]
 
function SetExpFrameLevel(value)
    MainStatusTrackingBarContainer:SetFrameLevel(value)
    statusBars.exp.StatusBar:SetFrameLevel(MainStatusTrackingBarContainer:GetFrameLevel()-1)
    --statusBars.exp.ExhaustionLevelFillBar:SetFrameLevel(MainStatusTrackingBarContainer:GetFrameLevel())
    statusBars.exp.OverlayFrame:SetFrameLevel(MainStatusTrackingBarContainer:GetFrameLevel()+32)
    statusBars.exp.ExhaustionTick:SetFrameLevel(MainStatusTrackingBarContainer:GetFrameLevel()+3)
    statusBars.exp.ExhaustionTick:SetFrameStrata("MEDIUM")
end

function SetRepFrameLevel(value)
    SecondaryStatusTrackingBarContainer:SetFrameLevel(value)
    SecondaryStatusTrackingBarContainer:SetFrameStrata("LOW")
    statusBars.rep.StatusBar:SetFrameLevel(SecondaryStatusTrackingBarContainer:GetFrameLevel()-1)
    statusBars.rep.OverlayFrame:SetFrameLevel(SecondaryStatusTrackingBarContainer:GetFrameLevel()+32)
end

--Set the frame strata for when the Exp bar is hovered over
local function hoverExpForeground()
    --Fix for the bottom 3 buttons needing to be on top of the art
    --MultiBarBottomRightButton8:SetParent(JadeUIBarArtFrame)
    --MultiBarBottomRightButton9:SetParent(JadeUIBarArtFrame)
    --MultiBarBottomRightButton10:SetParent(JadeUIBarArtFrame)
    --MultiBarBottomRight:SetFrameLevel(4)
    JadeUIBarTopArtFrame:SetFrameLevel(JadeUIBarArtFrame:GetFrameLevel()-3)
    JadeUIBarTopArtFrame:SetFrameStrata("LOW")
    SetExpFrameLevel(JadeUIBarArtFrame:GetFrameLevel()-1)
    SetRepFrameLevel(JadeUIBarTopArtFrame:GetFrameLevel()-3)
end

--Set the frame strata for when the Rep bar is hovered over
local function hoverRepForeground()
    hoverExpForeground()
    SetRepFrameLevel(JadeUIBarTopArtFrame:GetFrameLevel()+2)
end

--Set the frame strata for when no longer hovering over the bars
local function hoverExpBackground()
    JadeUI.SetDefaultStrata()
    --MultiBarBottomRightButton8:SetParent(MultiBarBottomRight)
    --MultiBarBottomRightButton9:SetParent(MultiBarBottomRight)
    --MultiBarBottomRightButton10:SetParent(MultiBarBottomRight)
end


--------------------------------------------
--Functions to move Blizzard Bars
--------------------------------------------

local function moveBlizzStatusBars()
    StatusTrackingBarManager:ClearAllPoints()
    StatusTrackingBarManager:SetParent(JadeUIBar)
    StatusTrackingBarManager:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 41)
    StatusTrackingBarManager:SetWidth(598)
    StatusTrackingBarManager:SetHeight(20) --Default 23
end

local function moveBlizzExpBar()
    --Exp Bar
    MainStatusTrackingBarContainer:ClearAllPoints()
    MainStatusTrackingBarContainer:SetPoint("TOPLEFT", MainStatusTrackingBarContainer:GetParent(), "LEFT", 0, statusBars.Offset)
    MainStatusTrackingBarContainer:SetPoint("BOTTOMRIGHT", MainStatusTrackingBarContainer:GetParent(), "BOTTOMRIGHT", 0, 0)
    --These are necessary for the bar to scale to the container
    statusBars.exp.StatusBar:SetPoint("TOPLEFT", statusBars.exp.StatusBar:GetParent(), "TOPLEFT", 0, 0)
    statusBars.exp.StatusBar:SetPoint("BOTTOMRIGHT", statusBars.exp.StatusBar:GetParent(), "BOTTOMRIGHT", 0, 0)
    statusBars.exp.ExhaustionTick:UpdateTickPosition() --Replacement for the ExhaustionTick_OnEvent using the new mixins - https://github.com/Gethe/wow-ui-source/blob/33e177d9bf38d76d5c6c6e05d5da78db1899659a/Interface/AddOns/Blizzard_ActionBar/Shared/ExpBar.lua#L27
    --This is specifically for when the rep bar replaces the main bar at max level
    statusBars.exp.RepStatusBar:SetPoint("TOPLEFT", statusBars.exp.StatusBar:GetParent(), "TOPLEFT", 0, 0)
    statusBars.exp.RepStatusBar:SetPoint("BOTTOMRIGHT", statusBars.exp.StatusBar:GetParent(), "BOTTOMRIGHT", 0, 0)

    statusBars.exp.StatusBar:GetParent():HookScript("OnEnter", function(self, motion) hoverExpForeground() end)
    statusBars.exp.StatusBar:GetParent():HookScript("OnLeave", function(self, motion) hoverExpBackground() end)

    statusBars.exp.ExhaustionTick:HookScript("OnEnter", function(self, motion) hoverExpForeground() end)
    statusBars.exp.ExhaustionTick:HookScript("OnLeave", function(self, motion) hoverExpBackground() end)
end

local function moveBlizzRepBar()
    --Rep Bar
    SecondaryStatusTrackingBarContainer:ClearAllPoints()
    SecondaryStatusTrackingBarContainer:SetPoint("TOPLEFT", SecondaryStatusTrackingBarContainer:GetParent(), "TOPLEFT", 0, 0)
    SecondaryStatusTrackingBarContainer:SetPoint("BOTTOMRIGHT", SecondaryStatusTrackingBarContainer:GetParent(), "RIGHT", 0, statusBars.Offset)
    --These are necessary for the bar to scale to the container
    statusBars.rep.StatusBar:SetPoint("TOPLEFT", statusBars.rep.StatusBar:GetParent(), "TOPLEFT", 0, 0)
    statusBars.rep.StatusBar:SetPoint("BOTTOMRIGHT", statusBars.rep.StatusBar:GetParent(), "BOTTOMRIGHT", 0, 0)

    statusBars.rep.StatusBar:GetParent():HookScript("OnEnter", function(self, motion) hoverRepForeground() end)
    statusBars.rep.StatusBar:GetParent():HookScript("OnLeave", function(self, motion) hoverExpBackground() end)
end


--------------------------------------------
--Functions to replace default textures
--------------------------------------------
local function createMaxLevelCover()
    JadeUIMaxLevelCover = JadeUIBar:CreateTexture("JadeUIMaxLevelCover")
    JadeUIMaxLevelCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    JadeUIMaxLevelCover:SetTexture(textures.g13MaxCoverTexture)
    JadeUIMaxLevelCover:SetDrawLayer("BACKGROUND", -1)
end


local function replaceBlizzExpBarTexture()
    JadeUI.HideBlizzardFrame(MainStatusTrackingBarContainer.MainMenuBarFrameTexture1)
    JadeUI.HideBlizzardFrame(MainStatusTrackingBarContainer.MainMenuBarFrameTexture2)
    JadeUI.HideBlizzardFrame(MainStatusTrackingBarContainer.MainMenuBarFrameTexture3)
    JadeUI.HideBlizzardFrame(MainStatusTrackingBarContainer.MainMenuBarFrameTexture4)
    JadeUIExpBarCover = JadeUIBar:CreateTexture("JadeUIExpBarCover")
    JadeUIExpBarCover:SetPoint("BOTTOM", MainStatusTrackingBarContainer, "BOTTOM", 0, 2)
    JadeUIExpBarCover:SetTexture(textures.g13ExpBarTexture)
    JadeUIExpBarCover:SetDrawLayer("BORDER", 7)
    JadeUIExpBarCover:SetParent(MainStatusTrackingBarContainer)
end

local function replaceBlizzRepBarTexture()
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTexture1)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTexture2)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTexture3)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTexture4)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTexture5)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTextureRightCapTop)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTextureRightCapBottom)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTextureLeftCapTop)
    JadeUI.HideBlizzardFrame(SecondaryStatusTrackingBarContainer.StandaloneFrameTextureLeftCapBottom)
    JadeUIRepBarCover = JadeUIBar:CreateTexture("JadeUIRepBarCover")
    JadeUIRepBarCover:SetPoint("BOTTOM", SecondaryStatusTrackingBarContainer, "BOTTOM", 0, 0)
    JadeUIRepBarCover:SetTexture(textures.g13RepBarTexture)
    JadeUIRepBarCover:SetDrawLayer("BORDER", 7)
    JadeUIRepBarCover:SetParent(SecondaryStatusTrackingBarContainer)
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
function expBar.BlizzExpBarMove()
    moveBlizzStatusBars()
    moveBlizzExpBar()
    replaceBlizzExpBarTexture()
    createMaxLevelCover()
end

function expBar.BlizzRepBarMove()
    moveBlizzRepBar()
    replaceBlizzRepBarTexture()
end

--Show/Hide the Max level cover depending on your level or tracked faction status
function expBar.showMaxCover()
    if UnitLevel("player") < GetMaxPlayerLevel() or GetWatchedFactionInfo() then
        JadeUIMaxLevelCover:Hide()
    else
        JadeUIMaxLevelCover:Show()
    end
 end