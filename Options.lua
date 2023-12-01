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

        local itemSpacingTop = -30
        local itemSpacing = -5

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

        -- add widgets to the panel as desired
        local title = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
        title:SetPoint("TOP")
        title:SetText("JadeUI Classic")

        local cb = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, itemSpacingTop)
        local text = "Show Talent Button"
        cb.Text:SetText(text)
        cb.tooltipText = text --Yellow tooltip name
        cb.tooltipRequirement = "This option will display the talent button in the Menu Bar regardless of player level" --White tooltip description
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = cb:GetChecked()
            UpdateMicroButtons()
        end)
        cb:SetChecked(JadeUIDB.showTalents)
        print(JadeUIDB.showTalents)

        local cb2 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb2:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, itemSpacing)
        local text = "Move Unitframes"
        cb2.Text:SetText(text)
        cb2.tooltipText = text --Yellow tooltip name
        cb2.tooltipRequirement = "Move the player unitframes down to the bottom centre of the screen\nReload required to disable" --White tooltip description
        -- there already is an existing OnClick script that plays a sound, hook it
        cb2:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveUnitFrames = cb2:GetChecked()
            if not cb2:GetChecked() then
                C_UI.Reload()
            else
                JadeUI.blizzUIMove()
            end
        end)
        cb2:SetChecked(JadeUIDB.moveUnitFrames)

        local cb3 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, itemSpacing)
        local text = "Move Minimap"
        cb3.Text:SetText(text)
        cb3.tooltipText = text --Yellow tooltip name
        cb3.tooltipRequirement = "Move the Minimap down to the bottom right corner of the screen\nReload required to disable" --White tooltip description
        -- there already is an existing OnClick script that plays a sound, hook it
        cb3:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveMinimap = cb3:GetChecked()
            if not cb3:GetChecked() then
                C_UI.Reload()
            else
                JadeUI.blizzUIMove()
            end
        end)
        cb3:SetChecked(JadeUIDB.moveMinimap)

        local cb4 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb4:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, itemSpacing)
        local text = "1:1 UI Scale"
        cb4.Text:SetText(text)
        cb4.tooltipText = text --Yellow tooltip name
        cb4.tooltipRequirement = "Set the UI scaling so that elements display at a 1:1 pixel ratio" --White tooltip description
        -- there already is an existing OnClick script that plays a sound, hook it
        cb4:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.pixelScale = cb4:GetChecked()
            JadeUI.SetScale()
        end)
        cb4:SetChecked(JadeUIDB.pixelScale)


        --Create a dropdown to manage Endstops
        local endstopLabel = optionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
        endstopLabel:SetPoint("TOPLEFT", optionsPanel, "TOP", 0, itemSpacingTop)
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



