--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ... --Discard the addon name and set the namespace table as a variable

--Check for project type
JadeUI.isVanilla = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC)
JadeUI.isTBC = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE)
JadeUI.isWrath = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_NORTHREND)

JadeUIBar = CreateFrame("Frame", "JadeUI Main Frame", UIParent)

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


--------------------------------------------------------------------------------
--Event Handler
--------------------------------------------------------------------------------
JadeUIBar:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        startupPrint()
    end

    if event == "PLAYER_ENTERING_WORLD" then
        JadeUIBar:SetFrameStrata("MEDIUM")
        JadeUIBar:SetFrameLevel(1)
        JadeUIBar:SetSize(745, 210)
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
            JadeUI.preventActionBarMovement() --Disable Blizzard dynamic UI positioning
            JadeUIButtonParent = CreateFrame("Frame", "JadeUI Button Parent", JadeUIBar)
            JadeUIButtonParent:SetFrameLevel(3)
            JadeUI.blizzBarMove() --Move the Blizzard Action Bars
            JadeUI.xpBar.BlizzXPBarMove()
            JadeUI.xpBar.showMaxCover()
            MainMenuBar:Hide() --Hide Blizzard Main Bar
        else
            JadeUI.bartenderFix() --Fix some issues with Bartender
        end
    end

end)



--[[ Frame levels
Medium
0 - UIParent
1 - XP Bar
2 - Art Bar
3 - Buttons 
4 - XP Bar Hover
5 - Endstops

When bar is hovered over, 

]]