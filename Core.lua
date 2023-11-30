--------------------------------------------
--Check for project type
--------------------------------------------
local isVanilla = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC)
local isTBC = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE)
local isWrath = (LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_NORTHREND)

--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ... --Discard the addon name and set the namespace table as a variable
JadeUIBar = CreateFrame("Frame", "JadeUI Main Frame", UIParent)

--------------------------------------------------------------------------------
--Core Functions
--------------------------------------------------------------------------------
local function startupPrint() --Startup message
    print ("~JadeUI~")
    if isVanilla or isTBC or isWrath then
        print("Classic WoW Detected")
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
        JadeUIDB = JadeUIDB or {} --Create a table for saved variables
        JadeUIDB.blizzXPBar = (JadeUIDB.blizzXPBar or 0)
        JadeUIDB.endstopType = (JadeUIDB.endstopType or 0)
        JadeUIDB.mouseover = (JadeUIDB.mouseover or 0)
        JadeUIDB.moveMinimap = (JadeUIDB.moveMinimap or 0)
        JadeUIDB.minimapScale = (JadeUIDB.minimapScale or 0)
        JadeUIDB.moveUnitFrames = (JadeUIDB.moveUnitFrames or 0)
        JadeUIDB.stanceBarHide = (JadeUIDB.stanceBarHide or 0)
        JadeUIDB.keyCover = (JadeUIDB.keyCover or 0)
    end

    if event == "PLAYER_ENTERING_WORLD" then
        JadeUIBar:SetFrameStrata("BACKGROUND")
        JadeUIBar:SetSize(745, 210)
        JadeUIBar:SetPoint("BOTTOM", UIParent, "BOTTOM")
        JadeUI.createArtFrame()
        MainMenuBar:Hide()
        --local width,height = GetPhysicalScreenSize()
        --UIParent:SetScale((768/height)*2)
    end

end)
