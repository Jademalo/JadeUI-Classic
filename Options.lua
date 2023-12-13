--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local itemSpacingLeft = -5 --The space between each entry in the list
local itemSpacingRight = -5 --The space between each entry in the list
local optionsPanel = CreateFrame("Frame") --The main options panel frame
optionsPanel.name = "JadeUI Classic" --CreateFrame call (CreateFrame("Frame", "Name")) puts "Name" in the global scope, so _G["Name"] will retrieve the panel. The panel.name is a field on the panel itself.

--Register ADDON_LOADED to run the main code when the addon is loaded
optionsPanel:RegisterEvent("ADDON_LOADED")

--Initialise SavedVariables
local function savedVariablesInit()
    JadeUIDB = JadeUIDB or {} --Create a table for saved variables if one isn't loaded

    local defaults = {
        showTalents = false, --0 is truthy, so only false or nil will result in the default being read.
        moveUnitFrames = true,
        moveMinimap = true,
        minimapScaleFactor = 1.33,
        endstopType = 1,
        pixelScale = false,
        levelScreenshot = true,
        hideKeybinds = true,

        blizzXPBar = 0,
        mouseover = 0,
        stanceBarHide = 0,
        keyCover = 0
    }

    for key, value in pairs(defaults) do
        if JadeUIDB[key] == nil then
            JadeUIDB[key] = value
        end
    end

end


--------------------------------------------
--Functions
--------------------------------------------  
--Adds tooltipText and tooltipRequirement to a frame
local function addTooltip(frame) 
    frame:SetScript("OnEnter", function(self)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
            GameTooltip:Show()
        end
        if self.tooltipRequirement then
            GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1)
            GameTooltip:Show()
        end
    end )
    frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
end

--This makes a dynamic options list on the left-hand side
JadeUI.OptionsListLeft = {}
local function appendOptionLeft(frame, spacing)
    spacing = spacing or itemSpacingLeft
    if next(JadeUI.OptionsListLeft)==nil then --If there are no existing options in the list
        frame:SetPoint("TOPLEFT", optionsPanel, "TOPLEFT", 20, -30) --Set it to the top left of the options panel
    else
        frame:SetPoint("TOPLEFT", JadeUI.OptionsListLeft[#JadeUI.OptionsListLeft], "BOTTOMLEFT", 0, spacing) --Append it below the previous entry in the options list
    end
    table.insert(JadeUI.OptionsListLeft, frame) --Add this frame to the options list
end

--This makes a dynamic options list on the right-hand side
JadeUI.OptionsListRight = {}
local function appendOptionRight(frame, spacing)
    spacing = spacing or itemSpacingRight
    if next(JadeUI.OptionsListRight)==nil then --If there are no existing options in the list
        frame:SetPoint("TOPLEFT", optionsPanel, "TOP", 0, -30) --Set it to the centre of the options panel
    else
        frame:SetPoint("TOPLEFT", JadeUI.OptionsListRight[#JadeUI.OptionsListRight], "BOTTOMLEFT", 0, spacing) --Append it below the previous entry in the options list
    end
    table.insert(JadeUI.OptionsListRight, frame) --Add this frame to the options list
end

--Checkbox Factory
local function createCheckbox(name, description, savedVariable)
    local checkboxFrame = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    appendOptionLeft(checkboxFrame)
    checkboxFrame.Text:SetText(name or "")
    checkboxFrame.tooltipText = name or ""
    checkboxFrame.tooltipRequirement = description or ""
    checkboxFrame:SetChecked(savedVariable)
    return checkboxFrame
end

--Round to decimals - https://warcraft.wiki.gg/wiki/Round
local function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end


--------------------------------------------------------------------------------
--Reload button
--------------------------------------------------------------------------------
local reloadButton = CreateFrame('button', nil, optionsPanel, 'UIPanelButtonTemplate')
reloadButton:SetSize(120, 22)
reloadButton:SetText("Reload UI")
reloadButton:SetPoint('BOTTOM', 0, 20)
reloadButton:Hide()
reloadButton:SetScript('OnClick', function(self)
    C_UI.Reload()
end)


--------------------------------------------
--Left Column Menu Entries
--------------------------------------------        
local function buildLeftColumn()
    --Title
    local title = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("JadeUI Classic")

    --Checkbox for showing the talent button
    local talentCheckbox = createCheckbox(
        "Show Talent Button",
        "This option will display the talent button in the Menu Bar regardless of player level",
        JadeUIDB.showTalents
    )
    talentCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.showTalents = talentCheckbox:GetChecked()
        UpdateMicroButtons()
    end)

    --Checkbox for moving the unitframes
    local unitFramesCheckbox = createCheckbox(
        "Move Unitframes",
        "Move the player unitframes down to the bottom centre of the screen\nReload required to disable",
        JadeUIDB.moveUnitFrames
    )
    unitFramesCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.moveUnitFrames = unitFramesCheckbox:GetChecked()
        if not unitFramesCheckbox:GetChecked() then
            reloadButton:Show()
        else
            JadeUI.moveUnitFramesFunc()
        end
    end)

    --Checkbox for moving the Minimap
    local minimapCheckbox = createCheckbox(
        "Move Minimap",
        "Move the Minimap down to the bottom right corner of the screen\nReload required to disable",
        JadeUIDB.moveMinimap
    )
    minimapCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.moveMinimap = minimapCheckbox:GetChecked()
        if not minimapCheckbox:GetChecked() then
            reloadButton:Show()
        else
            JadeUI.MoveMinimapFunc()
        end
    end)

    --Checkbox for taking a screenshot on level up
    local levelScreenshotCheckbox = createCheckbox(
        "Screenshot on Level Up",
        "Automatically take a screenshot on levelling up",
        JadeUIDB.levelScreenshot
    )
    levelScreenshotCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.levelScreenshot = levelScreenshotCheckbox:GetChecked()
    end)

    --Checkbox for taking a screenshot on level up
    local hideKeybindsCheckbox = createCheckbox(
        "Hide Keybinds",
        "Hides keybinds on action bars\nReload required to disable",
        JadeUIDB.hideKeybinds
    )
    hideKeybindsCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.hideKeybinds = hideKeybindsCheckbox:GetChecked()
        if not hideKeybindsCheckbox:GetChecked() then
            reloadButton:Show()
        else
            JadeUI.HideKeybinds()
        end
    end)

    --Checkbox for forcing a specific UI Scale
    local uiScaleCheckbox = createCheckbox(
        "1:1 UI Scale",
        "Set the UI scaling so that elements display at a 1:1 pixel ratio",
        JadeUIDB.pixelScale
    )
    uiScaleCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.pixelScale = uiScaleCheckbox:GetChecked()
        JadeUI.SetScale()
    end)

end


--------------------------------------------
--Right Column Menu Entries
--------------------------------------------  
local function buildRightColumn()
    --Create a dropdown to manage Endstops
        --Title
    local endstopLabel = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
    appendOptionRight(endstopLabel)
    endstopLabel:SetText('Select endstop artwork:')

        --Dropdown Box
    local endstopDropDown = CreateFrame("Frame", "Endstop Menu", optionsPanel, "UIDropDownMenuTemplate")
    endstopDropDown:SetPoint("TOPLEFT", endstopLabel, "BOTTOMLEFT", -15, -5)
    table.insert(JadeUI.OptionsListRight, endstopDropDown) --This frame has it's relative point set manually since it needs to be closer, and is added manually
    UIDropDownMenu_SetWidth(endstopDropDown, 100)
    addTooltip(endstopDropDown) --Add a tooltip to the dropdown
    endstopDropDown.tooltipText = "Select Endstop Artwork"
    endstopDropDown.tooltipRequirement = "Select the artwork to be displayed for the endstops on the main bar"
    UIDropDownMenu_Initialize(endstopDropDown, function(frame, level, menulist) --Args passed to this function are (frame, level, menulist), where frame is the first arg here. This function is run to init the box.
        local endstopTypes = { "None", "Gryphon", "Lion" }
            for i, type in next, endstopTypes do
                local info = UIDropDownMenu_CreateInfo()
                info.text = type
                info.value = i-1
                info.func = function(self, arg1, arg2, checked) --Args passed to this are (self (info in this case), arg1, arg2, checked). This function is run on click.
                    JadeUI.setEndstop(self.value)
                    JadeUIDB.endstopType = self.value
                    UIDropDownMenu_SetSelectedValue(frame,self.value) --This sets the label after selecting an option
                end
                UIDropDownMenu_AddButton(info)
            end
        UIDropDownMenu_SetSelectedValue(frame, JadeUIDB.endstopType) --This sets the label initially based on the SavedVariable
    end)

    --Create a slider to adjust Minimap Scale
    local scaleSlider = CreateFrame("Slider", "Minimap Scale Slider", optionsPanel, "OptionsSliderTemplate")
    appendOptionRight(scaleSlider, -15)

    local minRange = 1
    local maxRange = 1.5
    scaleSlider:SetMinMaxValues(minRange, maxRange)
    _G[scaleSlider:GetName() .. 'Low']:SetText(minRange)
    _G[scaleSlider:GetName() .. 'High']:SetText(maxRange)
    _G[scaleSlider:GetName() .. 'Text']:SetText("Minimap Scale")

    --addTooltip(endstopDropDown) --Add a tooltip to the slider
    scaleSlider.tooltipText = "Minimap Scale"
    scaleSlider.tooltipRequirement = "Select the scale for the Minimap"
    scaleSlider:SetOrientation("HORIZONTAL")

    local stepSize = 0.05
    scaleSlider:SetValueStep(stepSize)
    scaleSlider:SetObeyStepOnDrag(true)
    scaleSlider:SetValue(JadeUIDB.minimapScaleFactor)

    local scaleSliderValue = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
    scaleSliderValue:SetPoint("TOP", scaleSlider, "BOTTOM", 0, 3)
    scaleSliderValue:SetText(round(JadeUIDB.minimapScaleFactor, 2))

    scaleSlider:HookScript('OnValueChanged', function(self, value, userInput)
        if userInput then
            JadeUIDB.minimapScaleFactor = round(value, 2)
            scaleSliderValue:SetText(JadeUIDB.minimapScaleFactor)
            JadeUI.MinimapScaleFunc()
        end
    end)



end





--------------------------------------------------------------------------------
--Event Handler
--------------------------------------------------------------------------------
optionsPanel:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then

        savedVariablesInit()
        buildLeftColumn()
        buildRightColumn()

        --Register the Options Panel in the AddOn Menu
        InterfaceOptions_AddCategory(optionsPanel)
    end

end)



