local addonName, JadeUI = ...
local edit = JadeUI.edit

----------------------------------
-- Layout Modification
----------------------------------
local function actionBars(layout)
    local MainActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 1)
    local LeftEndCap = edit.GetSystem(layout, Enum.EditModeSystem.MainActionBarEndCap, 1)
    local MultiBarBottomLeft = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 2)
    local MultiBarBottomRight = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 3)
    local PetActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 12)
    local PossessActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 13)
    local MultiCastActionBarFrame = edit.GetSystem(layout, Enum.EditModeSystem.TotemActionBar)

    if JadeUIDB["gameboardType"] == 0 then

        --MainActionBar
        edit.SetOption(MainActionBar, 2, 7) --# of Icons
        edit.SetOption(MainActionBar, 8, 1) --Hide bar scrolling
        edit.SetPoint(MainActionBar, "BOTTOM", "UIParent", "BOTTOM", 0, 98)

        --MultiBarBottomLeft
        edit.SetOption(MultiBarBottomLeft, 1, 1) --# of Rows
        edit.SetOption(MultiBarBottomLeft, 2, 7) --# of Icons
        edit.SetOption(MultiBarBottomLeft, 6, 0) --Add Hide Bar Art and set false
        edit.SetPoint(MultiBarBottomLeft, "BOTTOM", "MainActionBar", "TOP", 0, 3)

        --MultiBarBottomRight
        edit.SetOption(MultiBarBottomRight, 1, 2) --# of Rows
        edit.SetOption(MultiBarBottomRight, 2, 10) --# of Icons
        edit.SetOption(MultiBarBottomRight, 6, 0) --Add Hide Bar Art and set false
        edit.SetPoint(MultiBarBottomRight, "TOP", "MainActionBar", "BOTTOM", 0, -3)

    elseif JadeUIDB["gameboardType"] == 1 then

        --MainActionBar
        edit.SetOption(MainActionBar, 2, 6) --# of Icons
        edit.SetOption(MainActionBar, 8, 1) --Hide bar scrolling
        edit.SetPoint(MainActionBar, "BOTTOM", "UIParent", "BOTTOM", 0, 98) --23.5 to offset so buttons are in the middle

        --MultiBarBottomLeft
        edit.SetOption(MultiBarBottomLeft, 1, 2) --# of Rows
        edit.SetOption(MultiBarBottomLeft, 2, 12) --# of Icons
        edit.SetOption(MultiBarBottomLeft, 6, 0) --Add Hide Bar Art and set false
        edit.SetPoint(MultiBarBottomLeft, "BOTTOM", "MainActionBar", "TOP", 0, 3)

        --MultiBarBottomRight
        edit.SetOption(MultiBarBottomRight, 1, 2) --# of Rows
        edit.SetOption(MultiBarBottomRight, 2, 10) --# of Icons
        edit.SetOption(MultiBarBottomRight, 6, 0) --Add Hide Bar Art and set false
        edit.SetPoint(MultiBarBottomRight, "TOPLEFT", "MainActionBar", "BOTTOMLEFT", 0, -3)

    end

    --LeftEndCap
    edit.SetPoint(LeftEndCap, "BOTTOMRIGHT", "MicroMenu", "BOTTOMLEFT", 28.25, -7)

    --Stance Bar, Pet Bar, and Possess Bar all stack when default above MainActionBar
    --PetActionBar
    edit.SetOption(PetActionBar, 3, 4) --Icon size
    --Position without Bar Art
    edit.SetPoint(PetActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", -1, 5)
    --Position with Bar Art
    --edit.SetPoint(PetActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 8)
    --edit.SetOption(PetActionBar, 6, 0) --Add Hide Bar Art and set false
    --edit.SetOption(PetActionBar, 9, 1) --Always show buttons

    --PossessActionBar
    edit.SetPoint(PossessActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 8)
    edit.SetOption(PossessActionBar, 6, 0) --Add Hide Bar Art and set false

    --MultiCastActionBarFrame
    edit.SetPoint(MultiCastActionBarFrame, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 8)

end

local function stanceBar(layout)
    local StanceBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 11)
    if Settings.GetValue(addonName.."_offsetStanceBar") == true then
        --StanceBar
        edit.SetPoint(StanceBar, "BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 0, 5)
        --edit.SetOption(StanceBar, 6, 0) --Add Hide Bar Art and set false
    else
        edit.SetPoint(StanceBar, "BOTTOM", "MultiBarBottomLeft", "TOP", -1, 5)
    end
end

local function microMenu(layout)
    --MicroMenu
    local MicroMenu = edit.GetSystem(layout, Enum.EditModeSystem.MicroMenu)
    if JadeUIDB["gameboardType"] == 0 then
        edit.SetPoint(MicroMenu, "BOTTOMRIGHT", "MultiBarBottomRight", "BOTTOMLEFT", 38.5, 2)
    elseif JadeUIDB["gameboardType"] == 1 then
        edit.SetPoint(MicroMenu, "BOTTOMRIGHT", "MultiBarBottomRight", "BOTTOMLEFT", -6, 2)
    end
end

local function bagsBar(layout)
    --BagsBar
    local BagsBar = edit.GetSystem(layout, Enum.EditModeSystem.Bags)
    edit.SetPoint(BagsBar, "BOTTOMLEFT", "MultiBarBottomRight", "BOTTOMRIGHT", -41.5, -1)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
end

local function durabilityFrame(layout)
    --DurabilityFrame
    local DurabilityFrame = edit.GetSystem(layout, Enum.EditModeSystem.DurabilityFrame)
    edit.SetPoint(DurabilityFrame, "LEFT", "MainActionBar", "TOPRIGHT", 88.5, 1)
end

local function statusBars(layout)
    local MainStatusTrackingBarContainer = edit.GetSystem(layout, Enum.EditModeSystem.StatusTrackingBar, 1)
    local SecondaryStatusTrackingBarContainer = edit.GetSystem(layout, Enum.EditModeSystem.StatusTrackingBar, 2)

    if JadeUIDB["gameboardType"] == 0 then
        --STATUS_BAR_MANAGER_WIDTH = 772 --Override the base variable for status bar width - https://github.com/Gethe/wow-ui-source/blob/e3ecc27b64d30fdc735a3f6579b866858f9f9df1/Interface/AddOns/Blizzard_StatusTrackingBar/Shared/StatusTrackingManager.lua#L6

        --MainStatusTrackingBarContainer
        edit.SetOption(MainStatusTrackingBarContainer, 3, 3) --Width
        edit.SetPoint(MainStatusTrackingBarContainer, "BOTTOMLEFT", "MicroMenu", "TOPLEFT", -3, 6)

        --SecondaryStatusTrackingBarContainer
        edit.SetOption(SecondaryStatusTrackingBarContainer, 3, 3) --Width
        edit.SetPoint(SecondaryStatusTrackingBarContainer, "BOTTOMLEFT", "MainStatusTrackingBarContainer", "TOPLEFT", 0, -1)

    elseif JadeUIDB["gameboardType"] == 1 then
        --MainStatusTrackingBarContainer
        edit.SetOption(MainStatusTrackingBarContainer, 3, 4) --Width
        edit.SetPoint(MainStatusTrackingBarContainer, "BOTTOM", "MultiBarBottomRight", "CENTER", -18, 2)

        --SecondaryStatusTrackingBarContainer
        edit.SetOption(SecondaryStatusTrackingBarContainer, 3, 4) --Width
        edit.SetPoint(SecondaryStatusTrackingBarContainer, "BOTTOM", "MainStatusTrackingBarContainer", "TOP", 0, -1)
    end

end

local function unitFrames(layout)
    if Settings.GetValue(addonName.."_moveUnitFrames") == true then
        --PlayerFrame
        local PlayerFrame = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 1)
        edit.SetPoint(PlayerFrame, "BOTTOMRIGHT", "MultiBarBottomLeft", "TOP", -160, 39)

        --TargetFrame
        local TargetFrame = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 2)
        edit.SetPoint(TargetFrame, "BOTTOMLEFT", "MultiBarBottomLeft", "TOP", 160, 39)

        --FocusFrame
        local FocusFrame = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 3)
        --edit.SetPoint(FocusFrame, "BOTTOMLEFT", "PlayerFrame", "TOPRIGHT", -26, -26) --Traditional Top Right of player frame position
        edit.SetPoint(FocusFrame, "TOP", "PlayerFrame", "BOTTOM", 0, -20)
    else
        edit.SetDefault(layout, Enum.EditModeSystem.UnitFrame, 1)
        edit.SetDefault(layout, Enum.EditModeSystem.UnitFrame, 2)
        edit.SetDefault(layout, Enum.EditModeSystem.UnitFrame, 3)
    end
end

local function castBars(layout)
    local visibility = 1 --0: Always Visible, 1: In Combat, 2: Hidden
    local width = 100
    local height = 5
    local SwingTimerMainHandFrame = edit.GetSystem(layout, Enum.EditModeSystem.SwingTimer, 1)
    local SwingTimerOffHandFrame = edit.GetSystem(layout, Enum.EditModeSystem.SwingTimer, 2)
    local SwingTimerRangedFrame = edit.GetSystem(layout, Enum.EditModeSystem.SwingTimer, 3)
    local PlayerCastingBarFrame = edit.GetSystem(layout, Enum.EditModeSystem.CastBar)

    --Cast Bar
    if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(PlayerCastingBarFrame, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 120) end
    edit.SetOption(PlayerCastingBarFrame, 2, visibility) --Visibility

    --SwingTimerMainHandFrame
    if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(SwingTimerMainHandFrame, "TOP", "PlayerCastingBarFrame", "BOTTOM", 0, -20) end
    edit.SetOption(SwingTimerMainHandFrame, 2, visibility) --Visibility
    edit.SetOption(SwingTimerMainHandFrame, 3, width) --Width
    edit.SetOption(SwingTimerMainHandFrame, 4, height) --Height

    --SwingTimerOffHandFrame
    if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(SwingTimerOffHandFrame, "TOP", "SwingTimerMainHandFrame", "BOTTOM", 0, 0) end
    edit.SetOption(SwingTimerOffHandFrame, 2, visibility) --Visibility
    edit.SetOption(SwingTimerOffHandFrame, 3, width) --Width
    edit.SetOption(SwingTimerOffHandFrame, 4, 0) --Height

    --SwingTimerRangedFrame
    if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(SwingTimerRangedFrame, "TOP", "SwingTimerOffHandFrame", "BOTTOM", 0, 0) end
    edit.SetOption(SwingTimerRangedFrame, 2, visibility) --Visibility
    edit.SetOption(SwingTimerRangedFrame, 3, width) --Width
    edit.SetOption(SwingTimerRangedFrame, 4, height) --Height

end

local function minimap(layout)
    local MinimapCluster = edit.GetSystem(layout, Enum.EditModeSystem.Minimap)
    local BuffFrame = edit.GetSystem(layout, Enum.EditModeSystem.AuraFrame, 1)
    local DebuffFrame = edit.GetSystem(layout, Enum.EditModeSystem.AuraFrame, 2)
    local MultiBarRight = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 4)
    local MultiBarLeft = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 5)
    local GameTooltip = edit.GetSystem(layout, Enum.EditModeSystem.HudTooltip)
    local BossTargetFrameContainer = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 6)
    local ObjectiveTrackerFrame = edit.GetSystem(layout, Enum.EditModeSystem.ObjectiveTracker)

    if Settings.GetValue(addonName.."_moveMinimap") == true then

        --Minimap
        edit.SetPoint(MinimapCluster, "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, 0)
        edit.SetOption(MinimapCluster, 0, 1) --Header Underneath
        --Buffs
        edit.SetPoint(BuffFrame, "TOPRIGHT", "UIParent", "TOPRIGHT", -10, -10)
        --Debuffs
        edit.SetPoint(DebuffFrame, "TOPRIGHT", "UIParent", "TOPRIGHT", -25, -155)
        --ActionBars
        edit.SetPoint(MultiBarRight, "BOTTOMRIGHT", "MinimapCluster", "TOPRIGHT", -5, -0)
        edit.SetPoint(MultiBarLeft, "RIGHT", "MultiBarRight", "LEFT", -5, -0)
        --GameTooltip
        edit.SetPoint(GameTooltip, "BOTTOMRIGHT", "MinimapCluster", "BOTTOMLEFT", -9, 85)
        --Boss Frames
        if JadeUIDB["taintSafety"] > 0 then edit.SetPoint(BossTargetFrameContainer, "LEFT", "UIParent", "LEFT", 10, 0) end
        if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(ObjectiveTrackerFrame, "TOPRIGHT", "MultiBarLeft", "TOPLEFT", -5, 0) end

        JadeUI.minimapTainted = true

    else

        if JadeUI.minimapTainted then --Specifically only do this if the minimap config is tainted
            edit.SetDefault(layout, Enum.EditModeSystem.Minimap)
            edit.SetDefault(layout, Enum.EditModeSystem.AuraFrame, 1)
            edit.SetDefault(layout, Enum.EditModeSystem.AuraFrame, 2)
            edit.SetDefault(layout, Enum.EditModeSystem.ActionBar, 4)
            edit.SetDefault(layout, Enum.EditModeSystem.ActionBar, 5)
            edit.SetDefault(layout, Enum.EditModeSystem.HudTooltip)
            edit.SetDefault(layout, Enum.EditModeSystem.UnitFrame, 6)
            edit.SetDefault(layout, Enum.EditModeSystem.ObjectiveTracker)

            JadeUI.minimapTainted = false
        end

    end
end

----------------------------------
-- Layout Activation
----------------------------------
function JadeUI.SetJadeUILayout(forceInit)
    --Only switch to the JadeUI profile if the re-init button is pressed, or if the profile is being created
    forceInit = forceInit or false

    local baseLayout = C_EditMode.GetLayouts()
    local jadeUILayout, initProfile = edit.GenerateLayout(baseLayout, forceInit)

    actionBars(jadeUILayout)
    stanceBar(jadeUILayout)
    microMenu(jadeUILayout)
    bagsBar(jadeUILayout)
    durabilityFrame(jadeUILayout)
    statusBars(jadeUILayout)
    unitFrames(jadeUILayout)
    castBars(jadeUILayout)
    minimap(jadeUILayout)

    C_EditMode.SaveLayouts(edit.UpdateLayout(baseLayout, jadeUILayout))

    --Set JadeUI to the active layout if re-initialised, or if already applied to fix bar backgrounds
    if initProfile or C_EditMode.GetLayouts().activeLayout == JadeUI.layoutIndex then
        C_EditMode.SetActiveLayout(JadeUI.layoutIndex)
    end

end
