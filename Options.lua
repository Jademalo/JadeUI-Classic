--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local itemSpacing = -5 --The space between each entry in the list
local optionsPanel = CreateFrame("Frame") --The main options panel frame
optionsPanel.name = "JadeUI Classic" --CreateFrame call (CreateFrame("Frame", "Name")) puts "Name" in the global scope, so _G["Name"] will retrieve the panel. The panel.name is a field on the panel itself.

--Register ADDON_LOADED to run the main code when the addon is loaded
optionsPanel:RegisterEvent("ADDON_LOADED")

--Initialise SavedVariables
local function savedVariablesInit()
    JadeUIDB = JadeUIDB or {} --Create a table for saved variables
        JadeUIDB.showTalents = (JadeUIDB.showTalents or false) --0 is truthy, so only false or nil will result in the default being read.
        JadeUIDB.moveUnitFrames = (JadeUIDB.moveUnitFrames or false)
        JadeUIDB.moveMinimap = (JadeUIDB.moveMinimap or false)
        JadeUIDB.minimapScale = (JadeUIDB.minimapScale or false)
        JadeUIDB.minimapScaleFactor = (JadeUIDB.minimapScaleFactor or 1.33)
        JadeUIDB.endstopType = (JadeUIDB.endstopType or 1)
        JadeUIDB.pixelScale = (JadeUIDB.pixelScale or false)

        JadeUIDB.blizzXPBar = (JadeUIDB.blizzXPBar or 0)
        JadeUIDB.mouseover = (JadeUIDB.mouseover or 0)
        JadeUIDB.stanceBarHide = (JadeUIDB.stanceBarHide or 0)
        JadeUIDB.keyCover = (JadeUIDB.keyCover or 0)
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
local function appendOptionLeft(frame)
    if next(JadeUI.OptionsListLeft)==nil then --If there are no existing options in the list
        frame:SetPoint("TOPLEFT", optionsPanel, "TOPLEFT", 20, -30) --Set it to the top left of the options panel
    else
        frame:SetPoint("TOPLEFT", JadeUI.OptionsListLeft[#JadeUI.OptionsListLeft], "BOTTOMLEFT", 0, itemSpacing) --Append it below the previous entry in the options list
    end
    table.insert(JadeUI.OptionsListLeft, frame) --Add this frame to the options list
end

--This makes a dynamic options list on the right-hand side
JadeUI.OptionsListRight = {}
local function appendOptionRight(frame)
    if next(JadeUI.OptionsListRight)==nil then --If there are no existing options in the list
        frame:SetPoint("TOPLEFT", optionsPanel, "TOP", 0, -30) --Set it to the centre of the options panel
    else
        frame:SetPoint("TOPLEFT", JadeUI.OptionsListRight[#JadeUI.OptionsListRight], "BOTTOMLEFT", 0, itemSpacing) --Append it below the previous entry in the options list
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
            C_UI.Reload()
        else
            JadeUI.moveUnitFramesFunc()
        end
    end)

    --Checkbox for moving the Minimap
    local minimapcheckbox = createCheckbox(
        "Move Minimap",
        "Move the Minimap down to the bottom right corner of the screen\nReload required to disable",
        JadeUIDB.moveMinimap
    )
    minimapcheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.moveMinimap = minimapcheckbox:GetChecked()
        if not minimapcheckbox:GetChecked() then
            C_UI.Reload()
        else
            JadeUI.MoveMinimapFunc()
        end
    end)

    --Checkbox for increasing the size of the Minimap
    local minimapScaleCheckbox = createCheckbox(
        "Minimap Size",
        "Increase the size of the Minimap",
        JadeUIDB.minimapScale
    )
    minimapScaleCheckbox:HookScript("OnClick", function(_, btn, down)
        JadeUIDB.minimapScale = minimapScaleCheckbox:GetChecked()
        JadeUI.MinimapScaleFunc()
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
local function endstopDropDownInitialise(frame, level, menulist) --The initialisation function for the dropdown
    local endstopTypes = { "None", "Gryphon", "Lion" }
    for i, type in next, endstopTypes do
        local info = UIDropDownMenu_CreateInfo()
        info.text = type
        info.value = i-1
        info.func = function(self, arg1, arg2, checked) --Args passed to this are (self (info in this case), arg1, arg2, checked)
            JadeUI.setEndstop(self.value)
            JadeUIDB.endstopType = self.value
            UIDropDownMenu_SetSelectedValue(frame,self.value) --This sets the label after selecting an option
        end
        UIDropDownMenu_AddButton(info)
    end
    UIDropDownMenu_SetSelectedValue(frame, JadeUIDB.endstopType) --This sets the label initially based on the SavedVariable
end

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

    --Create a scroll bar to adjust Minimap scale
    --TODO

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



