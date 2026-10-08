local addonName, JadeUI = ...
local baseLayout = C_EditMode.GetLayouts()
local jadeUILayout = JadeUI.defaultLayout

--Get layout
--If the layout doesn't contain JadeUI, import the default to edit
--If it does, import existing to edit
--This means changes outside of the managed frames will be saved

----------------------------------
-- Layout Modification
----------------------------------
--SetPoint equivalent to modify the anchor info of a given system
local function editModeSetPoint(system, point, relativeTo, relativePoint, offsetX, offsetY)
    system.anchorInfo = {
        ["relativeTo"] = relativeTo,
        ["point"] = point,
        ["relativePoint"] = relativePoint,
        ["offsetY"] = offsetY,
        ["offsetX"] = offsetX,
    }
    system.isInDefaultPosition = false
end


local function actionBars()
    --MainActionBar
    local MainActionBar = jadeUILayout.systems[1]
    MainActionBar.settings[3].value = 7 --# of Icons
    MainActionBar.settings[7].value = 1 --Hide Bar Scrolling
    editModeSetPoint(MainActionBar, "BOTTOM", "UIParent", "BOTTOM", 0, 95)
    --LeftEndCap
    local LeftEndCap = jadeUILayout.systems[53]
    editModeSetPoint(LeftEndCap, "BOTTOMRIGHT", "MicroMenu", "BOTTOMLEFT", 28.25, -7)

    --MultiBarBottomLeft
    local MultiBarBottomLeft = jadeUILayout.systems[2]
    MultiBarBottomLeft.settings[3].value = 7 --# of Icons
    MultiBarBottomLeft.settings[8] = {["value"] = 0 ,["setting"] = 6,} --Add Hide Bar Art and set false
    editModeSetPoint(MultiBarBottomLeft, "BOTTOM", "MainActionBar", "TOP", 0, 0)

    --MultiBarBottomRight
    local MultiBarBottomRight = jadeUILayout.systems[3]
    MultiBarBottomRight.settings[2].value = 2 --# of Rows
    MultiBarBottomRight.settings[3].value = 10 --# of Icons
    MultiBarBottomRight.settings[8] = {["value"] = 0 ,["setting"] = 6,} --Add Hide Bar Art and set false
    editModeSetPoint(MultiBarBottomRight, "TOP", "MainActionBar", "BOTTOM", 0, 0)
end

local function microMenu()
    --MicroMenu
    local MicroMenu = jadeUILayout.systems[33]
    editModeSetPoint(MicroMenu, "BOTTOMRIGHT", "MultiBarBottomRight", "BOTTOMLEFT", 38.5, 2)
end

local function bagsBar()
    --BagsBar
    local BagsBar = jadeUILayout.systems[34]
    editModeSetPoint(BagsBar, "BOTTOMLEFT", "MultiBarBottomRight", "BOTTOMRIGHT", -41.5, -1)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
end

local function statusBars()
    --STATUS_BAR_MANAGER_WIDTH = 772 --Override the base variable for status bar width - https://github.com/Gethe/wow-ui-source/blob/e3ecc27b64d30fdc735a3f6579b866858f9f9df1/Interface/AddOns/Blizzard_StatusTrackingBar/Shared/StatusTrackingManager.lua#L6
    --MainStatusTrackingBarContainer
    local MainStatusTrackingBarContainer = jadeUILayout.systems[35]
    MainStatusTrackingBarContainer.settings[1].value = 3 --Width
    editModeSetPoint(MainStatusTrackingBarContainer, "BOTTOMLEFT", "MicroMenu", "TOPLEFT", -3, 6)

    --SecondaryStatusTrackingBarContainer
    local SecondaryStatusTrackingBarContainer = jadeUILayout.systems[36]
    SecondaryStatusTrackingBarContainer.settings[1].value = 3 --Width
    editModeSetPoint(SecondaryStatusTrackingBarContainer, "BOTTOMLEFT", "MainStatusTrackingBarContainer", "TOPLEFT", 0, -1)
end

local function unitFrames()
    --PlayerFrame
    local PlayerFrame = jadeUILayout.systems[14]
    editModeSetPoint(PlayerFrame, "BOTTOMRIGHT", "UIParent", "BOTTOM", -163, 209)

    --TargetFrame
    local TargetFrame = jadeUILayout.systems[15]
    editModeSetPoint(TargetFrame, "BOTTOMLEFT", "UIParent", "BOTTOM", 163, 209)

    --FocusFrame
    local FocusFrame = jadeUILayout.systems[16]
    editModeSetPoint(FocusFrame, "BOTTOMLEFT", "PlayerFrame", "TOPRIGHT", -26, -26)
end

local function swingTimers()
    local visibility = 0 --0: Always Visible, 1: In Combat, 2: Hidden
    local width = 100
    local height = 5
    --SwingTimerMainHandFrame
    local SwingTimerMainHandFrame = jadeUILayout.systems[57]
    SwingTimerMainHandFrame.settings[3].value = visibility --Visibility
    SwingTimerMainHandFrame.settings[4].value = width --Width
    SwingTimerMainHandFrame.settings[5].value = height --Height

    --SwingTimerOffHandFrame
    local SwingTimerOffHandFrame = jadeUILayout.systems[58]
    SwingTimerOffHandFrame.settings[3].value = visibility --Visibility
    SwingTimerOffHandFrame.settings[4].value = width --Width
    SwingTimerOffHandFrame.settings[5].value = height --Height

    --SwingTimerRangedFrame
    local SwingTimerRangedFrame = jadeUILayout.systems[59]
    SwingTimerRangedFrame.settings[3].value = visibility --Visibility
    SwingTimerRangedFrame.settings[4].value = width --Width
    SwingTimerRangedFrame.settings[5].value = height --Height

end

----------------------------------
-- Layout Activation
----------------------------------

local function addLayout(addition)
    local baseLayout = C_EditMode.GetLayouts()

    -- Get index of JadeUI if it already exists
    local targetIndex = nil
    for index, layout in ipairs(baseLayout.layouts) do
        if layout.layoutName == addition.layoutName then
            targetIndex = index
            break
        end
    end

    --If JadeUI doesn't exist then update the table in the layout, else add it
    if targetIndex then
        baseLayout.layouts[targetIndex] = addition
    else
        table.insert(baseLayout.layouts, addition)
        targetIndex = #baseLayout.layouts
    end

    return baseLayout, targetIndex

end


function JadeUI.EnableJadeUILayout()

    local layoutOffset = 0
    --Offset the base index to index 4, which is the first custom layout
    if JadeUI.isForever then
        layoutOffset = 3
    end

    actionBars()
    microMenu()
    bagsBar()
    statusBars()
    unitFrames()
    swingTimers()

    local modifiedLayoutData, targetIndex = addLayout(jadeUILayout)

    C_EditMode.SaveLayouts(modifiedLayoutData)
    C_EditMode.SetActiveLayout(targetIndex+layoutOffset)

end
