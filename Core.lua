--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ... --Discard the addon name and set the namespace table as a variable
JadeUI.hookTable = {}

--Check for project type
JadeUI.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
JadeUI.isForever = (WOW_PROJECT_ID == WOW_PROJECT_CAMELOT)

JadeUIBar = CreateFrame("Frame", "JadeUIMainFrame", UIParent)

--------------------------------------------------------------------------------
--Core Functions
--------------------------------------------------------------------------------
local function startupPrint() --Startup message
    print ("~JadeUI~")
    if JadeUI.isClassic then
        print("Classic WoW Detected")
    end
    if JadeUI.isForever then
        print("WoW Forever Detected")
    end
end

--------------------------------------------------------------------------------
--Event Registration
--------------------------------------------------------------------------------
JadeUIBar:RegisterEvent("ADDON_LOADED")
JadeUIBar:RegisterEvent("PLAYER_ENTERING_WORLD")
JadeUIBar:RegisterEvent("PLAYER_LEVEL_UP") --Register the level up event to re-trigger the max cover after maxing


--------------------------------------------------------------------------------
--Event Handler
--------------------------------------------------------------------------------
JadeUIBar:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        startupPrint()
    end

    if event == "PLAYER_ENTERING_WORLD" then

        if JadeUIDB.pixelScale then
            JadeUI.SetScale()
        end

        --Create Main JadeUI Frame
        JadeUIBar:SetFrameStrata("MEDIUM")
        JadeUIBar:SetSize(790, 209)
        JadeUIBar:SetPoint("BOTTOM", UIParent, "BOTTOM")

        --[[         if JadeUI.isForever then  ]]
            JadeUI.SetJadeUILayout()
            if C_EditMode.GetLayouts().activeLayout == JadeUI.layoutIndex then
                --ExportToSavedVariables()
                JadeUI.SetupHooksForLayout()
            end
            JadeUIBar:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED") --Register this event to handle changing layouts
--[[         end ]]

        if JadeUI.isClassic then

            --Move various Blizzard frames
            --JadeUI.blizzUIMove()
            if not C_AddOns.IsAddOnLoaded("Bartender4") then
                JadeUIButtonParent = CreateFrame("Frame", "JadeUIButtonParent", JadeUIBar)
                --JadeUI.blizzBarMove() --Move the Blizzard Action Bars
            end
            JadeUI.createArtFrame() --Create the main art frame for the bars
            JadeUI.setEndstop(JadeUIDB.endstopType) --Set the endstop type based on the saved variable

            --Move Blizzard status bars if not using Bartender
            --JadeUI.expBar.BlizzExpBarMove()
            --JadeUI.expBar.BlizzRepBarMove()
            JadeUIBar:RegisterEvent("UPDATE_FACTION") --Register the update faction event to run Rep Bar Move after. For some reason if this isn't here, I get an error about JadeUIButtonParent
            --JadeUI.expBar.showMaxCover()

            --if C_AddOns.IsAddOnLoaded("Bartender4") then
                --JadeUI.bartenderFix() --Fix some issues with Bartender
            --end

            --JadeUI.SetDefaultStrata()
        end

    end

    if event == "PLAYER_LEVEL_UP" then

        if JadeUI.isClassic then
            JadeUI.expBar.showMaxCover()
        end

    end

    if event == "EDIT_MODE_LAYOUTS_UPDATED" then
        if C_EditMode.GetLayouts().activeLayout == JadeUI.layoutIndex then
            JadeUI.SetupHooksForLayout()
        else
            StaticPopup_Show("JADEUI_RELOAD_REQUIRED")
        end
    end

end)
