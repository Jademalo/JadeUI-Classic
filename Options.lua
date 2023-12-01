--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local optionsPanel = CreateFrame("Frame")
optionsPanel:RegisterEvent("ADDON_LOADED")

optionsPanel:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        JadeUIDB = JadeUIDB or {} --Create a table for saved variables
        JadeUIDB.showTalents = (JadeUIDB.showTalents or false)
        JadeUIDB.moveUnitFrames = (JadeUIDB.moveUnitFrames or false)
        JadeUIDB.moveMinimap = (JadeUIDB.moveMinimap or false)
        JadeUIDB.endstopType = (JadeUIDB.endstopType or 1)

        JadeUIDB.blizzXPBar = (JadeUIDB.blizzXPBar or 0)
        JadeUIDB.mouseover = (JadeUIDB.mouseover or 0)
        JadeUIDB.minimapScale = (JadeUIDB.minimapScale or 0)
        JadeUIDB.stanceBarHide = (JadeUIDB.stanceBarHide or 0)
        JadeUIDB.keyCover = (JadeUIDB.keyCover or 0)
        

        local optionsPanel = CreateFrame("Frame")
        optionsPanel.name = "JadeUI Classic"

        -- add widgets to the panel as desired
        local title = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
        title:SetPoint("TOP")
        title:SetText("JadeUI Classic")

        local cb = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -20)
        cb.Text:SetText("Show talent button regardless of level")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = cb:GetChecked()
            UpdateMicroButtons()
        end)
        cb:SetChecked(JadeUIDB.showTalents)
        print(JadeUIDB.showTalents)

        local cb2 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb2:SetPoint("TOPLEFT", 20, -50)
        cb2.Text:SetText("Move the Unitframes")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb2:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveUnitFrames = cb2:GetChecked()
            JadeUI.blizzUIMove()
        end)
        cb2:SetChecked(JadeUIDB.moveUnitFrames)
        print(JadeUIDB.moveUnitFrames)

        local cb3 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb3:SetPoint("TOPLEFT", 20, -80)
        cb3.Text:SetText("Move the Minimap")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb3:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.moveMinimap = cb3:GetChecked()
            JadeUI.blizzUIMove()
        end)
        cb3:SetChecked(JadeUIDB.moveMinimap)
        print(JadeUIDB.moveMinimap)


        local dropDown = CreateFrame("Frame", "Endstop Menu", optionsPanel, "UIDropDownMenuTemplate")
        dropDown:SetPoint("TOPLEFT", 20, -110)
        dropDown.Text:SetText("Endstop Type")
        UIDropDownMenu_SetWidth(dropDown, 200) -- Use in place of dropDown:SetWidth
        -- Bind an initializer function to the dropdown; see previous sections for initializer function examples.


        local function EndstopHandler(self, arg1, arg2, checked)
            JadeUI.setEndstop(arg1)
            JadeUIDB.endstopType = arg1
        end

        UIDropDownMenu_Initialize(dropDown, function(frame, level, menuList)
            local info = UIDropDownMenu_CreateInfo()
            info.func = EndstopHandler --This is called whenever an option is clicked, we're setting it to a separate handler function that's the same for all 3
            info.text, info.arg1, info.checked = "None", 0, JadeUIDB.endstopType == 0
            UIDropDownMenu_AddButton(info)
            info.text, info.arg1, info.checked = "Gryphon", 1, JadeUIDB.endstopType == 1
            UIDropDownMenu_AddButton(info)
            info.text, info.arg1, info.checked = "Lion", 2, JadeUIDB.endstopType == 2
            UIDropDownMenu_AddButton(info)
        end)


        InterfaceOptions_AddCategory(optionsPanel)  -- see InterfaceOptions API
    end

end)



