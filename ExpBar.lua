--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
local textures = JadeUI.textures
JadeUI.expBar = {}
local expBar = JadeUI.expBar


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
--Set the frame strata for when the Exp bar is hovered over
local function hoverExpForeground()
    ExhaustionTick:SetFrameLevel(10)
    --Fix for the bottom 3 buttons needing to be on top of the art
    MultiBarBottomRightButton8:SetParent(JadeUIBarArtFrame)
    MultiBarBottomRightButton9:SetParent(JadeUIBarArtFrame)
    MultiBarBottomRightButton10:SetParent(JadeUIBarArtFrame)
    MainMenuExpBar:SetFrameLevel(7)
    MultiBarBottomRight:SetFrameLevel(4)
    JadeUIBarTopArtFrame:SetFrameLevel(3)
end

--Set the frame strata for when the Rep bar is hovered over
local function hoverRepForeground()
    ReputationWatchBar:SetFrameLevel(6)
    hoverExpForeground()
end

--Set the frame strata for when no longer hovering over the bars
local function hoverExpBackground()
    JadeUI.SetDefaultStrata()
    MultiBarBottomRightButton8:SetParent(MultiBarBottomRight)
    MultiBarBottomRightButton9:SetParent(MultiBarBottomRight)
    MultiBarBottomRightButton10:SetParent(MultiBarBottomRight)
end


--------------------------------------------
--Functions to move Blizzard Bars
--------------------------------------------
local function moveBlizzExpBar()
    --Exp Bar
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetParent(JadeUIBar)
    MainMenuExpBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 39)
    MainMenuExpBar:SetWidth(588)
    hoverExpBackground()
    ExhaustionTick_OnEvent(_,"PLAYER_XP_UPDATE") --Force an event to run ExhaustionTick_OnEvent which handles setting the exhaustion tick relative to the xp bar - https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MainMenuBar.lua#L361

    MainMenuExpBar:HookScript("OnEnter", function(self, motion) hoverExpForeground() end)
    MainMenuExpBar:HookScript("OnLeave", function(self, motion) hoverExpBackground() end)

    ExhaustionTick:HookScript("OnEnter", function(self, motion) hoverExpForeground() end)
    ExhaustionTick:HookScript("OnLeave", function(self, motion) hoverExpBackground() end)
end

local function moveBlizzRepBar()
    --Exp Bar
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:SetParent(JadeUIBar)
    ReputationWatchBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 47)
    ReputationWatchBar:SetWidth(588)
    ReputationWatchBar.StatusBar:SetWidth(588)

    ReputationWatchBar:HookScript("OnEnter", function(self, motion) hoverRepForeground() end)
    ReputationWatchBar:HookScript("OnLeave", function(self, motion) hoverExpBackground() end)
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
    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()
    JadeUIExpBarCover = JadeUIBar:CreateTexture("JadeUIExpBarCover")
    JadeUIExpBarCover:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 5)
    JadeUIExpBarCover:SetTexture(textures.g13ExpBarTexture)
    JadeUIExpBarCover:SetDrawLayer("BORDER", 7)
    JadeUIExpBarCover:SetParent(MainMenuXPBarTexture0:GetParent())
end

local function replaceBlizzRepBarTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
    JadeUIRepBarCover = JadeUIBar:CreateTexture("JadeUIRepBarCover")
    JadeUIRepBarCover:SetPoint("CENTER", ReputationWatchBar.StatusBar, "CENTER", 0, 5)
    JadeUIRepBarCover:SetTexture(textures.g13RepBarTexture)
    JadeUIRepBarCover:SetDrawLayer("BORDER", 7)
    JadeUIRepBarCover:SetParent(ReputationWatchBar.StatusBar.WatchBarTexture0:GetParent())
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
function expBar.BlizzExpBarMove()
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