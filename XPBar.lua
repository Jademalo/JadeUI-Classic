--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
local textures = JadeUI.textures
JadeUI.xpBar = {}
local xpBar = JadeUI.xpBar


--------------------------------------------
--Functions to handle strata changes on mouseover
--------------------------------------------
--[[ MEDIUM
    Level 13    - MultiBarBottomLeftButtons
    Level 12    - ActionButtons + MultiBarBottomLeft
    Level 11    - JadeUIButtonParent
    Level 10    - ExhaustionTick
    Level 9     - MultiBarBottomRightButton8/9/10
    Level 8     - JadeUIBarArtPanel                                         - Must be on top of the Exp bar
    Level 7     - MainMenuExpBar                                            - Must be on top of the Rep bar
    Level 6     - ReputationWatchBar (Active)
    Level 5     - MultiBarBottomRightButtons
    Level 4     - MultiBarBottomRight
    Level 3     - JadeUIBarTopArtFrame
    Level 2     - ReputationWatchBar (Inactive)
    Level 1     - JadeUIBar (Invisible parent)
    Level 0     - UIParent
 ]]
local function hoverLevelForeground()
    ExhaustionTick:SetFrameLevel(10)
    --Fix for the bottom 3 buttons needing to be on top of the art
    MultiBarBottomRightButton8:SetParent(JadeUIBarArtPanel)
    MultiBarBottomRightButton9:SetParent(JadeUIBarArtPanel)
    MultiBarBottomRightButton10:SetParent(JadeUIBarArtPanel)
    MainMenuExpBar:SetFrameLevel(7)
    MultiBarBottomRight:SetFrameLevel(4)
    JadeUIBarTopArtFrame:SetFrameLevel(3)
end

local function hoverRepForeground()
    ReputationWatchBar:SetFrameLevel(6)
    hoverLevelForeground()
end

local function hoverLevelBackground()
    JadeUI.SetDefaultStrata()
    MultiBarBottomRightButton8:SetParent(MultiBarBottomRight)
    MultiBarBottomRightButton9:SetParent(MultiBarBottomRight)
    MultiBarBottomRightButton10:SetParent(MultiBarBottomRight)
end


--------------------------------------------
--Functions to move Blizzard Bars
--------------------------------------------
local function moveBlizzXPBar()
    --Exp Bar
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetParent(JadeUIBar)
    MainMenuExpBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 39)
    MainMenuExpBar:SetWidth(588)
    hoverLevelBackground()
    ExhaustionTick_OnEvent(_,"PLAYER_XP_UPDATE") --Force an event to run ExhaustionTick_OnEvent which handles setting the exhaustion tick relative to the xp bar - https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MainMenuBar.lua#L361

    MainMenuExpBar:HookScript("OnEnter", function(self, motion) hoverLevelForeground() end)
    MainMenuExpBar:HookScript("OnLeave", function(self, motion) hoverLevelBackground() end)

    ExhaustionTick:HookScript("OnEnter", function(self, motion) hoverLevelForeground() end)
    ExhaustionTick:HookScript("OnLeave", function(self, motion) hoverLevelBackground() end)
end

local function moveBlizzRepBar()
    --Exp Bar
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:SetParent(JadeUIBar)
    ReputationWatchBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 47)
    ReputationWatchBar:SetWidth(588)
    ReputationWatchBar.StatusBar:SetWidth(588)

    ReputationWatchBar:HookScript("OnEnter", function(self, motion) hoverRepForeground() end)
    ReputationWatchBar:HookScript("OnLeave", function(self, motion) hoverLevelBackground() end)
end


--------------------------------------------
--Functions to replace default textures
--------------------------------------------
local function createMaxLevelCover()
    local g13MaxCover = JadeUIBar:CreateTexture("JadeUI Max Level Cover")
    g13MaxCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    g13MaxCover:SetTexture(textures.g13MaxCoverTexture)
    g13MaxCover:SetDrawLayer("BACKGROUND", -1)
    xpBar.g13MaxCover = g13MaxCover
end


local function replaceBlizzXPBarTexture()
    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()
    local g13XPBar = JadeUIBar:CreateTexture("JadeUIXPBarCover")
    g13XPBar:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 5)
    g13XPBar:SetTexture(textures.g13XPBarTexture)
    g13XPBar:SetDrawLayer("BORDER", 7)
    g13XPBar:SetParent(MainMenuXPBarTexture0:GetParent())
    xpBar.g13XPBar = g13XPBar
end

local function ReplaceBlizzRepBarTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
    local g13RepBar = JadeUIBar:CreateTexture("JadeUIRepBarCover")
    g13RepBar:SetPoint("CENTER", ReputationWatchBar.StatusBar, "CENTER", 0, 5)
    g13RepBar:SetTexture(textures.g13RepBarTexture)
    g13RepBar:SetDrawLayer("BORDER", 7)
    g13RepBar:SetParent(ReputationWatchBar.StatusBar.WatchBarTexture0:GetParent())
    xpBar.g13RepBar = g13RepBar
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
function xpBar.BlizzXPBarMove()
    moveBlizzXPBar()
    replaceBlizzXPBarTexture()
    createMaxLevelCover()
end

function xpBar.BlizzRepBarMove()
    moveBlizzRepBar()
    ReplaceBlizzRepBarTexture()
end

--Show/Hide the Max level cover depending on your level or tracked faction status
function xpBar.showMaxCover()
    if UnitLevel("player") < GetMaxPlayerLevel() or GetWatchedFactionInfo() then
        xpBar.g13MaxCover:Hide()
    else
        xpBar.g13MaxCover:Show()
    end
 end