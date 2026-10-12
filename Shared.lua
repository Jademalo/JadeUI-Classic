--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ... --Discard the addon name and set the namespace table as a variable

--------------------------------------------
--Helper Functions
--------------------------------------------
--If the passed variable is a function calculate it, else return the variable.
local function calcFunction(var)
    if type(var) == "function" then --Calculate functions for the offsets if we're being passed one
        return var()
    else
        return var
    end
end

--Get a dynamic child object
function GetDynamicChildren(frame, child, index)
    index = index or 1

    local count = 0
    for _, children in ipairs({frame:GetChildren()}) do
        if children[child] then
            count = count + 1
            if count == index then
                return children[child]
            end
        end
    end
end

function GetIndexedChild(frame, index)
    local count = 0
    for _, child in ipairs({frame:GetChildren()}) do
        count = count + 1
        if count == index then
            return child
        end
    end
end

function GetIndexedRegion(frame, index)
    local count = 0
    for _, region in ipairs({frame:GetRegions()}) do
        count = count + 1
        if count == index then
            return region
        end
    end
end


--------------------------------------------
--Shared Functions
--------------------------------------------
function JadeUI.SetScale()
    if JadeUIDB.pixelScale then
        local width,height = GetPhysicalScreenSize()
        UIParent:SetScale((768/height)*1)
    else
        if C_CVar.GetCVar("useUiScale") == "1" then
            UIParent:SetScale(C_CVar.GetCVar("uiScale"))
        else
            UIParent:SetScale(2/3)
        end
    end
end

--Adapted from https://github.com/erikbrgn/AutoHideBinds/blob/main/AutoHideBinds.lua with permission
function JadeUI.HideKeybinds()
    local bars = {
        "Action",
        "MultiBarBottomLeft",
        "MultiBarBottomRight",
        "MultiBarRight",
        "MultiBarLeft",
        "MultiBar5",
        "MultiBar6",
        "MultiBar7"
    }
    for _, barName in ipairs(bars) do
        for buttonNumber = 1, 12 do
            local button = barName .. "Button" .. buttonNumber
            if _G[button] then
                _G[button .. "HotKey"]:Hide()
                _G[button .. "HotKey"].Show = function() end
            end
        end
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
        if InCombatLockdown() and JadeUIDB["taintSafety"] > 1 then return end --Don't fire during combat if in taintSafety 2

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
        if InCombatLockdown() and JadeUIDB["taintSafety"] > 1 then return end --Don't fire during combat if in taintSafety 2

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
        if InCombatLockdown() and JadeUIDB["taintSafety"] > 1 then return end --Don't fire during combat if in taintSafety 2
        if shown then
            frame:SetShown(false)
        end
    end)
    frame:SetShown(false)
end
