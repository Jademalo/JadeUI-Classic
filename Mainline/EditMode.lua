local addonName, JadeUI = ...
local reInit = true

--Get layout
--If the layout doesn't contain JadeUI, import the default to edit
--If it does, import existing to edit
--This means changes outside of the managed frames will be saved
--Make sure to actually apply the modified layouts *after* the edit functions

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

local function setEditModeSetting(system, id, value)

    --Look for existing settings in the array
    for _, entry in ipairs(system.settings) do
        if entry.setting == id then
            entry.value = value
            return
        end
    end

    --If setting not found, insert a new table to the array
    table.insert(system.settings, {
        ["setting"] = id,
        ["value"] = value,
    })
end


local function actionBars(layout)
    --MainActionBar
    local MainActionBar = layout.systems[1]
    setEditModeSetting(MainActionBar, 2, 7) --# of Icons
    setEditModeSetting(MainActionBar, 8, 1) --# of Icons
    editModeSetPoint(MainActionBar, "BOTTOM", "UIParent", "BOTTOM", 0, 95)
    --LeftEndCap
    local LeftEndCap = layout.systems[53]
    editModeSetPoint(LeftEndCap, "BOTTOMRIGHT", "MicroMenu", "BOTTOMLEFT", 28.25, -7)

    --MultiBarBottomLeft
    local MultiBarBottomLeft = layout.systems[2]
    setEditModeSetting(MultiBarBottomLeft, 2, 7) --# of Icons
    setEditModeSetting(MultiBarBottomLeft, 6, 0) --Add Hide Bar Art and set false
    editModeSetPoint(MultiBarBottomLeft, "BOTTOM", "MainActionBar", "TOP", 0, 0)

    --MultiBarBottomRight
    local MultiBarBottomRight = layout.systems[3]
    setEditModeSetting(MultiBarBottomRight, 1, 2) --# of Rows
    setEditModeSetting(MultiBarBottomRight, 2, 10) --# of Icons
    setEditModeSetting(MultiBarBottomRight, 6, 0) --Add Hide Bar Art and set false
    editModeSetPoint(MultiBarBottomRight, "TOP", "MainActionBar", "BOTTOM", 0, 0)
end

local function microMenu(layout)
    --MicroMenu
    local MicroMenu = layout.systems[33]
    editModeSetPoint(MicroMenu, "BOTTOMRIGHT", "MultiBarBottomRight", "BOTTOMLEFT", 38.5, 2)
end

local function bagsBar(layout)
    --BagsBar
    local BagsBar = layout.systems[34]
    editModeSetPoint(BagsBar, "BOTTOMLEFT", "MultiBarBottomRight", "BOTTOMRIGHT", -41.5, -1)

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
end

local function statusBars(layout)
    --STATUS_BAR_MANAGER_WIDTH = 772 --Override the base variable for status bar width - https://github.com/Gethe/wow-ui-source/blob/e3ecc27b64d30fdc735a3f6579b866858f9f9df1/Interface/AddOns/Blizzard_StatusTrackingBar/Shared/StatusTrackingManager.lua#L6
    --MainStatusTrackingBarContainer
    local MainStatusTrackingBarContainer = layout.systems[35]
    setEditModeSetting(MainStatusTrackingBarContainer, 3, 3) --Width
    editModeSetPoint(MainStatusTrackingBarContainer, "BOTTOMLEFT", "MicroMenu", "TOPLEFT", -3, 6)

    --SecondaryStatusTrackingBarContainer
    local SecondaryStatusTrackingBarContainer = layout.systems[36]
    setEditModeSetting(SecondaryStatusTrackingBarContainer, 3, 3) --Width
    editModeSetPoint(SecondaryStatusTrackingBarContainer, "BOTTOMLEFT", "MainStatusTrackingBarContainer", "TOPLEFT", 0, -1)
end

local function unitFrames(layout)
    --PlayerFrame
    local PlayerFrame = layout.systems[14]
    editModeSetPoint(PlayerFrame, "BOTTOMRIGHT", "UIParent", "BOTTOM", -163, 209)

    --TargetFrame
    local TargetFrame = layout.systems[15]
    editModeSetPoint(TargetFrame, "BOTTOMLEFT", "UIParent", "BOTTOM", 163, 209)

    --FocusFrame
    local FocusFrame = layout.systems[16]
    editModeSetPoint(FocusFrame, "BOTTOMLEFT", "PlayerFrame", "TOPRIGHT", -26, -26)
end

local function swingTimers(layout)
    local visibility = 0 --0: Always Visible, 1: In Combat, 2: Hidden
    local width = 100
    local height = 5
    --SwingTimerMainHandFrame
    local SwingTimerMainHandFrame = layout.systems[57]
    setEditModeSetting(SwingTimerMainHandFrame, 2, visibility) --Visibility
    setEditModeSetting(SwingTimerMainHandFrame, 3, width) --Width
    setEditModeSetting(SwingTimerMainHandFrame, 4, height) --Height

    --SwingTimerOffHandFrame
    local SwingTimerOffHandFrame = layout.systems[58]
    setEditModeSetting(SwingTimerOffHandFrame, 2, visibility) --Visibility
    setEditModeSetting(SwingTimerOffHandFrame, 3, width) --Width
    setEditModeSetting(SwingTimerOffHandFrame, 4, height) --Height

    --SwingTimerRangedFrame
    local SwingTimerRangedFrame = layout.systems[59]
    setEditModeSetting(SwingTimerRangedFrame, 2, visibility) --Visibility
    setEditModeSetting(SwingTimerRangedFrame, 3, width) --Width
    setEditModeSetting(SwingTimerRangedFrame, 4, height) --Height

end

----------------------------------
-- Layout Activation
----------------------------------

local function generateLayout(base)

    --Find the existing JadeUI layout if it exists
    local targetIndex = nil
    for index, layout in ipairs(base.layouts) do
        if layout.layoutName == JadeUI.defaultLayout.layoutName and not reInit then --If it finds an existing JadeUI layout and reInit is not enabled
            print("update")
            return layout
        end
    end

    --Return the existing JadeUI layout if it exists, else return the default blank layout
    print("init")
    return JadeUI.defaultLayout

end


local function updateLayout(base, addition)

    local layoutOffset = 0
    --Offset the base index to index 4, which is the first custom layout
    if JadeUI.isForever then
        layoutOffset = 3
    end

    -- Get index of JadeUI if it already exists
    local targetIndex = nil
    for index, layout in ipairs(base.layouts) do
        if layout.layoutName == addition.layoutName then
            targetIndex = index
            break
        end
    end

    --If JadeUI doesn't exist then update the table in the layout, else add it
    if targetIndex then
        base.layouts[targetIndex] = addition
    else
        table.insert(base.layouts, addition)
        targetIndex = #base.layouts
    end

    C_EditMode.SaveLayouts(base)
    C_EditMode.SetActiveLayout(targetIndex+layoutOffset)

end


function JadeUI.EnableJadeUILayout()

    local baseLayout = C_EditMode.GetLayouts()
    local jadeUILayout = generateLayout(baseLayout)

    actionBars(jadeUILayout)
    microMenu(jadeUILayout)
    bagsBar(jadeUILayout)
    statusBars(jadeUILayout)
    unitFrames(jadeUILayout)
    swingTimers(jadeUILayout)

    updateLayout(baseLayout, jadeUILayout)

end
