--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...

local optionsPanel = CreateFrame("Frame", "JadeUIOptionsPanel") --The main options panel frame

--Register ADDON_LOADED to run the main code when the addon is loaded
optionsPanel:RegisterEvent("ADDON_LOADED")


--------------------------------------------
--Functions
--------------------------------------------  
--Round to decimals - https://warcraft.wiki.gg/wiki/Round
local function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end


--------------------------------------------------------------------------------
--Buttons
--------------------------------------------------------------------------------
local function talentCheckbox(category)

    local variable = "showTalents"
    local name = "Show Talent Button"
    local description = "This option will display the talent button in the Menu Bar regardless of player level"
    local defaultValue = false

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        UpdateMicroButtons()
    end)

end

local function unitFramesCheckbox(category)

    local variable = "moveUnitFrames"
    local name = "Move Unitframes"
    local description = "Move the player unitframes down to the bottom centre of the screen"
    local defaultValue = true

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.TriggerFrameHooks()
        ActionBarController_UpdateAll()
    end)

end

local function minimapCheckbox(category)

    local variable = "moveMinimap"
    local name = "Move Minimap"
    local description = "Move the Minimap down to the bottom right corner of the screen"
    local defaultValue = true

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.TriggerFrameHooks()
        ActionBarController_UpdateAll()
    end)

end

local function hideKeybindsCheckbox(category)

    local variable = "hideKeybinds"
    local name = "Hide Keybinds"
    local description = "Hides keybinds on action bars\nReload required to disable"
    local defaultValue = true

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        if not JadeUIDB[variable] then
            C_UI.Reload()
        else
            JadeUI.HideKeybinds()
        end
    end)

end

local function uiScaleCheckbox(category)

    local variable = "pixelScale"
    local name = "1:1 UI Scale"
    local description = "Set the UI scaling so that elements display at a 1:1 pixel ratio"
    local defaultValue = false

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.SetScale()
    end)

end

local function endstopDropDown(category)

    local variable = "endstopType"
    local name = "Select Endstop Artwork"
    local description = "Select the artwork to be displayed for the endstops on the main bar"
    local defaultValue = 0

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        container:Add(0, "Gryphon", "Standard Gryphon art")
        container:Add(1, "Lion", "Alternate Lion art")
        container:Add(2, "None", "Remove the endstops entirely")
        return container:GetData()
    end
    Settings.CreateDropdown(category, setting, GetOptions, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.setEndstop(JadeUIDB[variable])
    end)

end

local function minimapScaleSlider(category)

    local variable = "minimapScaleFactor"
    local name = "Minimap Scale"
    local description = "Select the scale for the Minimap"
    local defaultValue = 1.35

    local minRange = 1
    local maxRange = 1.5
    local stepSize = 0.05

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minRange, maxRange, stepSize)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value) return round(value, 2) end)
    Settings.CreateSlider(category, setting, options, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.MinimapScaleFunc()
    end)

end

local function offsetStanceBarCheckbox(category)

    local variable = "offsetStanceBar"
    local name = "Offset Stance Bar"
    local description = "Move the Stance Bar to the left hand edge of the main frame"
    local defaultValue = false

    local setting = Settings.RegisterAddOnSetting(category, addonName.."_"..variable, variable, JadeUIDB, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, setting, description)

    Settings.GetSetting(addonName.."_"..variable):SetValueChangedCallback(function()
        JadeUI.TriggerFrameHooks()
    end)

end

--------------------------------------------------------------------------------
--Event Handler
--------------------------------------------------------------------------------
optionsPanel:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then

        JadeUIDB = JadeUIDB or {}

        --Register the Options Panel in the AddOn Menu
        local category, layout = Settings.RegisterVerticalLayoutCategory("JadeUI Classic")
        Settings.RegisterAddOnCategory(category)

        --Add Items
        if JadeUI.isClassic then
            talentCheckbox(category)
            offsetStanceBarCheckbox(category)
        end
        unitFramesCheckbox(category)
        hideKeybindsCheckbox(category)
        if JadeUI.isClassic then
            endstopDropDown(category)
        end
        minimapCheckbox(category)
        if JadeUI.isClassic then
            minimapScaleSlider(category)
        end
        uiScaleCheckbox(category)

    end

end)



