--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local optionsPanel = CreateFrame("Frame")
optionsPanel:RegisterEvent("ADDON_LOADED")

optionsPanel:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        JadeUIDB = JadeUIDB or {} --Create a table for saved variables
        JadeUIDB.blizzXPBar = (JadeUIDB.blizzXPBar or 0)
        JadeUIDB.endstopType = (JadeUIDB.endstopType or 0)
        JadeUIDB.mouseover = (JadeUIDB.mouseover or 0)
        JadeUIDB.moveMinimap = (JadeUIDB.moveMinimap or 0)
        JadeUIDB.minimapScale = (JadeUIDB.minimapScale or 0)
        JadeUIDB.moveUnitFrames = (JadeUIDB.moveUnitFrames or 0)
        JadeUIDB.stanceBarHide = (JadeUIDB.stanceBarHide or 0)
        JadeUIDB.keyCover = (JadeUIDB.keyCover or 0)
        JadeUIDB.showTalents = (JadeUIDB.showTalents or false)

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
        cb2:SetPoint("TOPLEFT", 20, -40)
        cb2.Text:SetText("Show talent button regardless of level")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb2:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = cb2:GetChecked()
            UpdateMicroButtons()
        end)
        cb2:SetChecked(JadeUIDB.showTalents)
        print(JadeUIDB.showTalents)

        local cb3 = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb3:SetPoint("TOPLEFT", 20, -60)
        cb3.Text:SetText("Show talent button regardless of level")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb3:HookScript("OnClick", function(_, btn, down)
            JadeUIDB.showTalents = cb3:GetChecked()
            UpdateMicroButtons()
        end)
        cb3:SetChecked(JadeUIDB.showTalents)
        print(JadeUIDB.showTalents)



        InterfaceOptions_AddCategory(optionsPanel)  -- see InterfaceOptions API
    end

end)



