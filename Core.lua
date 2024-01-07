--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ... --Discard the addon name and set the namespace table as a variable

--Check for project type
JadeUI.isVanilla = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC)
JadeUI.isTBC = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE)
JadeUI.isWrath = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_NORTHREND)

JadeUIBar = CreateFrame("Frame", "JadeUIMainFrame", UIParent)

--------------------------------------------------------------------------------
--Core Functions
--------------------------------------------------------------------------------
local function startupPrint() --Startup message
    print ("~JadeUI~")
    if JadeUI.isVanilla or JadeUI.isTBC or JadeUI.isWrath then
        print("Classic WoW Detected")
    end
end

function JadeUI.SetScale()
    if JadeUIDB.pixelScale then
        local width,height = GetPhysicalScreenSize()
        UIParent:SetScale((768/height)*1)
    else
        UIParent:SetScale(C_CVar.GetCVar("uiScale"))
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
        JadeUIBar:SetFrameStrata("MEDIUM")
        JadeUIBar:SetSize(790, 209)
        JadeUIBar:SetPoint("BOTTOM", UIParent, "BOTTOM")
        JadeUI.createArtFrame() --Create the main art frame for the bars
        JadeUI.setEndstop(JadeUIDB.endstopType) --Set the endstop type based on the saved variable

        if JadeUIDB.pixelScale then
            JadeUI.SetScale()
        end

        --Move various Blizzard frames
        JadeUI.blizzUIMove()

        --Move Blizzard Bars if not using Bartender
        if not C_AddOns.IsAddOnLoaded("Bartender4") then
            JadeUIButtonParent = CreateFrame("Frame", "JadeUIButtonParent", JadeUIBar)
            JadeUI.blizzBarMove() --Move the Blizzard Action Bars
            JadeUI.expBar.BlizzExpBarMove()
            JadeUI.expBar.BlizzRepBarMove()
            JadeUIBar:RegisterEvent("UPDATE_FACTION") --Register the update faction event to run Rep Bar Move after. For some reason if this isn't here, I get an error about JadeUIButtonParent
            JadeUI.expBar.showMaxCover()
        else
            JadeUI.bartenderFix() --Fix some issues with Bartender
        end

        JadeUI.SetDefaultStrata()
    end

    if event == "UPDATE_FACTION" then
        JadeUI.expBar.BlizzRepBarMove()
    end

    if event == "PLAYER_LEVEL_UP" then
        JadeUI.expBar.showMaxCover()
        if JadeUIDB.levelScreenshot then
            RequestTimePlayed() --Show /played when levelling up
            JadeUIBar:RegisterEvent("TIME_PLAYED_MSG") --Register the return of the message being sent to screenshot
        end
    end

    if event == "TIME_PLAYED_MSG" then
        C_Timer.After(0.5, function() Screenshot() end) --Take a screenshot on Level Up
        JadeUIBar:UnregisterEvent("TIME_PLAYED_MSG") --Unregister the event so it doesn't fire on every /played
    end

end)
