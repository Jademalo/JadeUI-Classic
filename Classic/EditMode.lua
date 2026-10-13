local addonName, JadeUI = ...
local edit = JadeUI.edit

----------------------------------
-- Layout Modification
----------------------------------
local function actionBars(layout)
    --MainActionBar
    local MainActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 1)
    edit.SetOption(MainActionBar, 2, 7) --# of Icons
    edit.SetOption(MainActionBar, 6, 1) --Hide bar art
    edit.SetOption(MainActionBar, 8, 1) --Hide bar scrolling
    edit.SetPoint(MainActionBar, "BOTTOM", "UIParent", "BOTTOM", -1, 88.5)

    --MultiBarBottomLeft
    local MultiBarBottomLeft = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 2)
    edit.SetOption(MultiBarBottomLeft, 2, 7) --# of Icons
    edit.SetOption(MultiBarBottomLeft, 6, 0) --Add Hide Bar Art and set false
    edit.SetPoint(MultiBarBottomLeft, "BOTTOM", "MainActionBar", "TOP", 0, 6.5)

    --MultiBarBottomRight
    local MultiBarBottomRight = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 3)
    edit.SetOption(MultiBarBottomRight, 1, 2) --# of Rows
    edit.SetOption(MultiBarBottomRight, 2, 10) --# of Icons
    edit.SetOption(MultiBarBottomRight, 6, 0) --Add Hide Bar Art and set false
    edit.SetPoint(MultiBarBottomRight, "TOP", "MainActionBar", "BOTTOM", 0, -6.5)

    --Stance Bar, Pet Bar, and Possess Bar all stack when default above MainActionBar
    --PetActionBar
    local PetActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 12)
    edit.SetOption(PetActionBar, 3, 2) --Icon size
    --Position without Bar Art
    --edit.SetPoint(PetActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", -1, 5)
    --Position with Bar Art
    edit.SetPoint(PetActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 13)
    edit.SetOption(PetActionBar, 6, 0) --Add Hide Bar Art and set false
    --edit.SetOption(PetActionBar, 9, 1) --Always show buttons

    --PossessActionBar
    local PossessActionBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 13)
    edit.SetPoint(PossessActionBar, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 8)
    edit.SetOption(PossessActionBar, 6, 0) --Add Hide Bar Art and set false

    --MultiCastActionBarFrame
    local MultiCastActionBarFrame = edit.GetSystem(layout, Enum.EditModeSystem.TotemActionBar)
    edit.SetPoint(MultiCastActionBarFrame, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 8)
end

local function stanceBar(layout)
    local StanceBar = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 11)
    if Settings.GetValue(addonName.."_offsetStanceBar") == true then
        --StanceBar
        edit.SetPoint(StanceBar, "BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 3.5, 14.5)
        --edit.SetOption(StanceBar, 6, 0) --Add Hide Bar Art and set false
    else
        edit.SetPoint(StanceBar, "BOTTOM", "MultiBarBottomLeft", "TOP", -0.5, 14.5)
    end
end

local function microMenu(layout)
    --MicroMenu
    local MicroMenu = edit.GetSystem(layout, Enum.EditModeSystem.MicroMenu)
    edit.SetPoint(MicroMenu, "BOTTOMRIGHT", "MultiBarBottomRight", "BOTTOMLEFT", 29.5, -2)
end

local function bagsBar(layout)
    --BagsBar
    local BagsBar = edit.GetSystem(layout, Enum.EditModeSystem.Bags)
    edit.SetPoint(BagsBar, "BOTTOMLEFT", "MultiBarBottomRight", "BOTTOMRIGHT", -37, -1.25)

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
    --MainStatusTrackingBarContainer
    local MainStatusTrackingBarContainer = edit.GetSystem(layout, Enum.EditModeSystem.StatusTrackingBar, 1)
    --edit.SetOption(MainStatusTrackingBarContainer, 3, 1.5) --Width
    edit.SetPoint(MainStatusTrackingBarContainer, "BOTTOMLEFT", "MicroMenu", "TOPLEFT", -11, 2)

    --SecondaryStatusTrackingBarContainer
    local SecondaryStatusTrackingBarContainer = edit.GetSystem(layout, Enum.EditModeSystem.StatusTrackingBar, 2)
    --edit.SetOption(SecondaryStatusTrackingBarContainer, 3, 2) --Width
    edit.SetPoint(SecondaryStatusTrackingBarContainer, "BOTTOM", "MainStatusTrackingBarContainer", "TOP", 0, 0)
end

local function unitFrames(layout)
    if Settings.GetValue(addonName.."_moveUnitFrames") == true then
        --PlayerFrame
        local PlayerFrame = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 1)
        edit.SetPoint(PlayerFrame, "BOTTOMRIGHT", "UIParent", "BOTTOM", -145.75, 212.5)

        --TargetFrame
        local TargetFrame = edit.GetSystem(layout, Enum.EditModeSystem.UnitFrame, 2)
        edit.SetPoint(TargetFrame, "BOTTOMLEFT", "UIParent", "BOTTOM", 145, 212.5)

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
    local PlayerCastingBarFrame = edit.GetSystem(layout, Enum.EditModeSystem.CastBar)
    --Cast Bar
    if JadeUIDB["taintSafety"] > 1 then edit.SetPoint(PlayerCastingBarFrame, "BOTTOM", "MultiBarBottomLeft", "TOP", 0, 117) end
end

local function minimap(layout)
    local MinimapCluster = edit.GetSystem(layout, Enum.EditModeSystem.Minimap)
    local BuffFrame = edit.GetSystem(layout, Enum.EditModeSystem.AuraFrame, 1)
    local DebuffFrame = edit.GetSystem(layout, Enum.EditModeSystem.AuraFrame, 2)
    local MultiBarRight = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 4)
    local MultiBarLeft = edit.GetSystem(layout, Enum.EditModeSystem.ActionBar, 5)

    if Settings.GetValue(addonName.."_moveMinimap") == true then

        --Minimap
        edit.SetPoint(MinimapCluster, "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, 0)
        edit.SetOption(MinimapCluster, 0, 1) --Header Underneath
        edit.SetOption(MinimapCluster, 2, JadeUIDB["minimapScaleFactor"])
        --Buffs
        edit.SetPoint(BuffFrame, "TOPRIGHT", "UIParent", "TOPRIGHT", -10, -10)
        --Debuffs
        edit.SetPoint(DebuffFrame, "TOPRIGHT", "UIParent", "TOPRIGHT", -25, -155)
        --ActionBars
        edit.SetPoint(MultiBarRight, "BOTTOMRIGHT", "MinimapCluster", "TOPRIGHT", -5, 30)
        edit.SetPoint(MultiBarLeft, "RIGHT", "MultiBarRight", "LEFT", -5, -0)

        JadeUI.minimapTainted = true

    else

        if JadeUI.minimapTainted then --Specifically only do this if the minimap config is tainted
            edit.SetDefault(layout, Enum.EditModeSystem.Minimap)
            edit.SetDefault(layout, Enum.EditModeSystem.AuraFrame, 1)
            edit.SetDefault(layout, Enum.EditModeSystem.AuraFrame, 2)
            edit.SetDefault(layout, Enum.EditModeSystem.ActionBar, 4)
            edit.SetDefault(layout, Enum.EditModeSystem.ActionBar, 5)

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
