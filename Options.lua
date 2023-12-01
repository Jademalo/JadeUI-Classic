--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local optionsPanel = CreateFrame("Frame")
optionsPanel:RegisterEvent("ADDON_LOADED")

optionsPanel:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        JadeUIDB = JadeUIDB or {} --Create a table for saved variables
            JadeUIDB.showTalents = (JadeUIDB.showTalents or false) --0 is truthy, so only false or nil will result in the default being read.
            JadeUIDB.moveUnitFrames = (JadeUIDB.moveUnitFrames or false)
            JadeUIDB.moveMinimap = (JadeUIDB.moveMinimap or false)
            JadeUIDB.endstopType = (JadeUIDB.endstopType or 1)
            JadeUIDB.pixelScale = (JadeUIDB.pixelScale or false)

            JadeUIDB.blizzXPBar = (JadeUIDB.blizzXPBar or 0)
            JadeUIDB.mouseover = (JadeUIDB.mouseover or 0)
            JadeUIDB.minimapScale = (JadeUIDB.minimapScale or 0)
            JadeUIDB.stanceBarHide = (JadeUIDB.stanceBarHide or 0)
            JadeUIDB.keyCover = (JadeUIDB.keyCover or 0)
        

        local optionsPanel = CreateFrame("Frame")
        optionsPanel.name = "JadeUI Classic" --CreateFrame call puts "Name" in the global scope, so _G["Name"] will retrieve the panel. The panel.name is a field on the panel itself.

        local itemSpacing = -5
        local optionsList = {}

        local function addTooltip(frame) --Adds tooltipText and tooltipRequirement to a frame
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

        local function createCheckbox(name, description, savedVariable, itemSpacing)
            local checkboxFrame = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
            if next(optionsList)==nil then --If there are no existing options in the list
                checkboxFrame:SetPoint("TOPLEFT", 20, -30) --Set it to the top left of the options panel
            else
                checkboxFrame:SetPoint("TOPLEFT", optionsList[#optionsList], "BOTTOMLEFT", 0, itemSpacing) --Append it below the previous entry in the options list
            end
            table.insert(optionsList, checkboxFrame) --Add this frame to the options list
            checkboxFrame.Text:SetText(name or "")
            checkboxFrame.tooltipText = name or ""
            checkboxFrame.tooltipRequirement = description or ""
            checkboxFrame:SetChecked(savedVariable)
            return checkboxFrame
        end


        local talentCheckbox = createCheckbox(
            "Show Talent Button",
            "This option will display the talent button in the Menu Bar regardless of player level",
            JadeUIDB.showTalents,
            itemSpacing
        )
        talentCheckbox:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = talentCheckbox:GetChecked()
            UpdateMicroButtons()
        end)

        local unitFramesCheckbox = createCheckbox(
            "Move Unitframes",
            "Move the player unitframes down to the bottom centre of the screen\nReload required to disable",
            JadeUIDB.moveUnitFrames,
            itemSpacing
        )
        unitFramesCheckbox:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveUnitFrames = unitFramesCheckbox:GetChecked()
            if not unitFramesCheckbox:GetChecked() then
                C_UI.Reload()
            else
                JadeUI.blizzUIMove()
            end
        end)

        local minimapcheckbox = createCheckbox(
            "Move Minimap",
            "Move the Minimap down to the bottom right corner of the screen\nReload required to disable",
            JadeUIDB.moveMinimap,
            itemSpacing
        )
        minimapcheckbox:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveMinimap = minimapcheckbox:GetChecked()
            if not minimapcheckbox:GetChecked() then
                C_UI.Reload()
            else
                JadeUI.blizzUIMove()
            end
        end)

        local uiScaleCheckbox = createCheckbox(
            "1:1 UI Scale",
            "Set the UI scaling so that elements display at a 1:1 pixel ratio",
            JadeUIDB.pixelScale,
            itemSpacing
        )
        uiScaleCheckbox:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.pixelScale = uiScaleCheckbox:GetChecked()
            JadeUI.SetScale()
        end)

        -- add widgets to the panel as desired
        local title = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
        title:SetPoint("TOP")
        title:SetText("JadeUI Classic")


        --Create a dropdown to manage Endstops
        local endstopLabel = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
        endstopLabel:SetPoint("TOPLEFT", optionsPanel, "TOP", 0, -30)
        endstopLabel:SetText('Select endstop artwork:')

        local endstopDropDown = CreateFrame("Frame", "Endstop Menu", optionsPanel, "UIDropDownMenuTemplate")
        addTooltip(endstopDropDown) --Add a tooltip to the dropdown

        local function endstopDropDownHandler(self, arg1, arg2, checked) --Arguments have to be (self, arg1, arg2, checked), self being info from UIDropDownMenu_CreateInfo (self.arg1 and arg1 are the same)  - https://www.townlong-yak.com/framexml/latest/UIDropDownMenu.lua#276
            JadeUI.setEndstop(self.value)
            JadeUIDB.endstopType = self.value
            UIDropDownMenu_SetSelectedValue(endstopDropDown,self.value) --This sets the label after selecting an option
        end

        local function endstopDropDownInitialise(frame, level, menulist) --The initialisation function for the dropdown
            local endstopTypes = { "None", "Gryphon", "Lion" }
            for i, type in next, endstopTypes do
                local info = UIDropDownMenu_CreateInfo()
                info.text = type
                info.value = i-1
                info.func = endstopDropDownHandler
                UIDropDownMenu_AddButton(info)
            end
            UIDropDownMenu_SetSelectedValue(endstopDropDown, JadeUIDB.endstopType) --This sets the label initially based on the SavedVariable
        end

        endstopDropDown:SetPoint("TOPLEFT", endstopLabel, "BOTTOMLEFT", -15, -5)
        UIDropDownMenu_SetWidth(endstopDropDown, 100)
        endstopDropDown.tooltipText = "Select Endstop Artwork"
        endstopDropDown.tooltipRequirement = "Select the artwork to be displayed for the endstops on the main bar"
        UIDropDownMenu_Initialize(endstopDropDown, endstopDropDownInitialise)





        InterfaceOptions_AddCategory(optionsPanel)  -- see InterfaceOptions API
    end

end)



