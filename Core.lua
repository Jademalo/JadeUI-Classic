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

function JadeUI.SetScale()
    if JadeUIDB.pixelScale then
        local width,height = GetPhysicalScreenSize()
        UIParent:SetScale((768/height)*1)
    else
        UIParent:SetScale(C_CVar.GetCVar("uiScale"))
    end
end

--If the passed variable is a function calculate it, else return the variable.
local function calcFunction(var)
    if type(var) == "function" then --Calculate functions for the offsets if we're being passed one
        return var()
    else
        return var
    end
end


--------------------------------------------
--Hooks
--------------------------------------------
--Trigger the hook for every frame by running SetPoint with their default position
function JadeUI.TriggerFrameHooks()
    for _, frame in pairs(JadeUI.hookTable) do
        frame:ClearAllPoints()
        frame:SetPoint(SafeUnpack(frame.defaultPos))
    end
end

--Move a frame by hooking its SetPoint and overriding it's position every time it tries to move
function JadeUI.MoveBlizzardFrame(frame, setPoint, setRelativePoint, setOffsetX, setOffsetY, setRelativeTo, savedVar)
    local hookSet = false
    table.insert(JadeUI.hookTable, frame) --Add any frame with a hook to the table of hooked frames (This adds the pointer to the table, not a copy)
    frame.defaultPos = {frame:GetPoint()} --Get the default position of the frame before the hook started to mess with things

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself

        if savedVar then
            if not JadeUIDB[savedVar] then return end
        end

        hookSet = true
            --local _,oldAnchor = frame:GetPoint()
            setRelativeTo = setRelativeTo or frame.defaultPos[2] --relativeTo is either the existing point or an arg if set manually

            frame:ClearAllPoints()
            frame:SetPoint(setPoint, setRelativeTo, setRelativePoint, calcFunction(setOffsetX), calcFunction(setOffsetY)) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)

    frame:SetPoint(frame:GetPoint()) --Fire SetPoint to fire the hook with the original frame data to prevent the hook from having bad data
end

--Offset a frame by hooking its SetPoint and adding the offset to its position
function JadeUI.OffsetBlizzardFrame(frame, setOffsetX, setOffsetY, setRelativeTo, savedVar)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself
        if savedVar then
            if not JadeUIDB[savedVar] then return end
        end

        local basePos = {frame:GetPoint()} --Back up the current position of the frame
        if (basePos[2] ~= UIParent) and (not setRelativeTo) then return end --Hacky fix for item tooltips and secondary bags being offset, while letting quest frame still move. Needs improvement.

        local offsetXCalc = basePos[4]+calcFunction(setOffsetX)
        local offsetYCalc = basePos[5]+calcFunction(setOffsetY)
        local setRelativeToOut = setRelativeTo or basePos[2] --If no new parent is defined, use the old one. Use a new variable so as not to pollute setRelativeTo and have subsequent runs of the hook get stuck on the first relative used

        hookSet = true
            frame:ClearAllPoints()
            frame:SetPoint(basePos[1], setRelativeToOut, basePos[3], offsetXCalc, offsetYCalc) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)
end

--Forcibly hide a frame by hooking Show and forcing it to hide whenever it tries
function JadeUI.HideBlizzardFrame(frame)
    hooksecurefunc(frame,"SetShown", function(self, shown) 
        if shown then
            frame:SetShown(false)
        end
     end)
    frame:SetShown(false)
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

        --Move various Blizzard frames
        JadeUI.blizzUIMove()
        if not C_AddOns.IsAddOnLoaded("Bartender4") then
            JadeUIButtonParent = CreateFrame("Frame", "JadeUIButtonParent", JadeUIBar)
            JadeUI.blizzBarMove() --Move the Blizzard Action Bars
        end

        if JadeUI.isClassic then
            JadeUI.createArtFrame() --Create the main art frame for the bars
            JadeUI.setEndstop(JadeUIDB.endstopType) --Set the endstop type based on the saved variable

            --Move Blizzard status bars if not using Bartender
            JadeUI.expBar.BlizzExpBarMove()
            JadeUI.expBar.BlizzRepBarMove()
            JadeUIBar:RegisterEvent("UPDATE_FACTION") --Register the update faction event to run Rep Bar Move after. For some reason if this isn't here, I get an error about JadeUIButtonParent
            JadeUI.expBar.showMaxCover()

            if C_AddOns.IsAddOnLoaded("Bartender4") then
                JadeUI.bartenderFix() --Fix some issues with Bartender
            end

            JadeUI.SetDefaultStrata()
        end

    end

    if event == "PLAYER_LEVEL_UP" then

        if JadeUI.isClassic then
            JadeUI.expBar.showMaxCover()
        end

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
