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

        -- add widgets to the panel as desired
        local title = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
        title:SetPoint("TOP")
        title:SetText("JadeUI Classic")

        local cb = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, itemSpacingTop)
        cb.Text:SetText("Show talent button regardless of level")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = cb:GetChecked()
            UpdateMicroButtons()
        end)
        cb:SetChecked(JadeUIDB.showTalents)
        print(JadeUIDB.showTalents)

        local cb2 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb2:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, itemSpacing)
        cb2.Text:SetText("Move the Unitframes")
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
        cb3.Text:SetText("Move the Minimap")
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
        cb4.Text:SetText("Scale the UI 1:1")
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
        UIDropDownMenu_Initialize(endstopDropDown, endstopDropDownInitialise)


        InterfaceOptions_AddCategory(optionsPanel)  -- see InterfaceOptions API
    end

end)



