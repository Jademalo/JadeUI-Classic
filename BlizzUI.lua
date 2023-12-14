--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...


--------------------------------------------
--Functions
--------------------------------------------
--Move a frame by hooking its SetPoint and overriding it's position every time it tries to move
local function moveBlizzardFrame(frame, setPoint, setRelativePoint, setOffsetX, setOffsetY, setRelativeTo)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself
        hookSet = true
            local _,oldAnchor = frame:GetPoint()
            setRelativeTo = setRelativeTo or oldAnchor --relativeTo is either the existing point or an arg if set manually

            frame:ClearAllPoints()
            frame:SetPoint(setPoint, setRelativeTo, setRelativePoint, setOffsetX, setOffsetY) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)

    frame:SetPoint(frame:GetPoint()) --Fire SetPoint to fire the hook with the original frame data to prevent the hook from having bad data
end

--Offset a frame by hooking its SetPoint and adding the offset to its position
local function offsetBlizzardFrame(frame, setOffsetX, setOffsetY, setRelativeTo)
    local hookSet = false

    hooksecurefunc(frame, "SetPoint", function()
        if hookSet then return end --Don't infinitely fire from itself

        --Hacky fix for item tooltips and secondary bags being offset
        if (frame == GameTooltip) or (frame == ContainerFrame2) or (frame == ContainerFrame3) or (frame == ContainerFrame4) or (frame == ContainerFrame5) then
            local _,anchor = frame:GetPoint()
            if anchor ~= UIParent then return end
        end

        local oldPos = {frame:GetPoint()} --Back up the current position of the frame
        local offsetCalcX = oldPos[4]+setOffsetX
        local offsetCalcY = oldPos[5]+setOffsetY
        setRelativeTo = setRelativeTo or oldPos[2] --If no new parent is defined, use the old one

        hookSet = true
            frame:ClearAllPoints()
            frame:SetPoint(oldPos[1], setRelativeTo, oldPos[3], offsetCalcX, offsetCalcY) --Make sure to get the actual scaled width of the minimap
        hookSet = false
    end)
end

--Forcibly hide a frame by hooking Show and forcing it to hide whenever it tries
local function hideBlizzardFrame(frame)
    hooksecurefunc(frame,"Show", function() frame:Hide() end)
    frame:Hide()
end

--[[ --Hook UIParent_ManageFramePosition to allow for additional overrides
local origUIParent_ManageFramePosition = UIParent_ManageFramePosition
UIParent_ManageFramePosition = function(index, value, yOffsetFrames, xOffsetFrames, hasBottomLeft, hasBottomRight, hasPetBar)

    origUIParent_ManageFramePosition(index, value, yOffsetFrames, xOffsetFrames, hasBottomLeft, hasBottomRight, hasPetBar)

end ]]





--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
function JadeUI.moveUnitFramesFunc()
    --Player Frame
    moveBlizzardFrame(PlayerFrame, "BOTTOMRIGHT", "BOTTOM", - 163, 200)
    --Target Frame
    moveBlizzardFrame(TargetFrame, "BOTTOMLEFT", "BOTTOM", 162, 200)

    if not JadeUI.isVanilla then
        --Focus Frame
        moveBlizzardFrame(FocusFrame, "BOTTOMLEFT", "BOTTOM", - 163, 250)
    end
end

--Fixes for the vertical multi bars to have them properly react to the minimap's position
local function verticalMultiBarFix()
    --Fix error when map at the bottom by anchoring the top of right actionbars to BuffFrame instead (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MultiActionBars.lua#L60)
    local oldMinimapGetBottom = MinimapCluster.GetBottom
    function MinimapCluster:GetBottom()
        if oldMinimapGetBottom(self) < (UIParent:GetBottom() + (MinimapCluster:GetHeight()*MinimapCluster:GetScale())) then --If minimap get bottom is below the height of the minimap cluster off the bottom of UIParent
            return BuffFrame:GetBottom() --Return the bottom of the Buff Bar
        else
            return oldMinimapGetBottom(self)*self:GetScale() --GetBottom gives a position value relative to the scale domain of the minimap, rather than UIParent. We need to fix that.
        end
    end

    --Adjust the right action bars to bottom anchor to the minimap size when above it (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MultiActionBars.lua#L65)
    function MainMenuBarArtFrame:GetTop()
        if oldMinimapGetBottom(MinimapCluster) < (UIParent:GetBottom() + (MinimapCluster:GetHeight()*MinimapCluster:GetScale())) then
            return MinimapCluster:GetTop()*MinimapCluster:GetScale() --GetTop gives a position value relative to the scale domain of the minimap, rather than UIParent. We need to fix that since the minimap scale might not be 0.
        else
            return JadeUIBarTopArtPanel:GetTop()*JadeUIBarTopArtPanel:GetScale() --GetTop gives a position value relative to the scale domain of the frame, rather than UIParent. We need to fix that since the frame scale might not be 0. 
        end
    end
end

function JadeUI.MoveMinimapFunc()
    --Minimap
    moveBlizzardFrame(MinimapCluster, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
    --Zone Text
    moveBlizzardFrame(MinimapZoneTextButton, "CENTER", "CENTER", 0, -77)
    --Minimap Toggle Button
    moveBlizzardFrame(MinimapToggleButton, "CENTER", "BOTTOMRIGHT", -15, 19)
    --Minimap Top Border
    moveBlizzardFrame(MinimapBorderTop, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
    --Clock
    moveBlizzardFrame(TimeManagerClockButton, "CENTER", "CENTER", 0, 75)

    --Buff Bar
    moveBlizzardFrame(BuffFrame, "TOPRIGHT", "TOPRIGHT", -13, -13, UIParent)
    --Quest Watch Frame
    offsetBlizzardFrame(QuestWatchFrame, 0, 0, BuffFrame)

    --Bags
    for i = 1, 5 do offsetBlizzardFrame(_G["ContainerFrame" .. i], -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())+VerticalMultiBarsContainer:GetWidth(), 0) end
    --Tooltip
    offsetBlizzardFrame(GameTooltip, -(MinimapCluster:GetWidth()*MinimapCluster:GetScale())+VerticalMultiBarsContainer:GetWidth(), 0)

    ActionBarController_UpdateAll() --This makes sure that the right hand bar gets repositioned after the minimap is moved around (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/ActionBarController.lua#L93)
end

function JadeUI.MinimapScaleFunc()
    MinimapCluster:SetScale(JadeUIDB.minimapScaleFactor)
    ActionBarController_UpdateAll() --This makes sure that the right hand bar gets repositioned after the minimap is moved around (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/ActionBarController.lua#L93)
end





--------------------------------------------
--Functions to move Blizzard Action Bars
--------------------------------------------
local function moveMicroMenu()

    hooksecurefunc("UpdateMicroButtons", function()
        local spacing = 2
        UpdateMicroButtonsParent(JadeUIButtonParent) --(https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MainMenuBarMicroButtons.lua#L60)
        
        CharacterMicroButton:SetPoint("BOTTOMLEFT", JadeUI.g13MainBar, "BOTTOM", - 288, 2)
        if JadeUIDB.showTalents == true or (UnitLevel("player") >= SHOW_SPEC_LEVEL) then
            spacing = -2.5
            TalentMicroButton:Show()
            TalentMicroButton:SetPoint("BOTTOMLEFT", SpellbookMicroButton, "BOTTOMRIGHT", spacing, 0)
            QuestLogMicroButton:SetPoint("BOTTOMLEFT", TalentMicroButton, "BOTTOMRIGHT", spacing, 0)
        else
            QuestLogMicroButton:SetPoint("BOTTOMLEFT", SpellbookMicroButton, "BOTTOMRIGHT", spacing, 0)
        end
        SpellbookMicroButton:SetPoint("BOTTOMLEFT", CharacterMicroButton, "BOTTOMRIGHT", spacing, 0)
        SocialsMicroButton:SetPoint("BOTTOMLEFT", QuestLogMicroButton, "BOTTOMRIGHT", spacing, 0)
        WorldMapMicroButton:SetPoint("BOTTOMLEFT", SocialsMicroButton, "BOTTOMRIGHT", spacing, 0)
        MainMenuMicroButton:SetPoint("BOTTOMLEFT", WorldMapMicroButton, "BOTTOMRIGHT", spacing, 0)
        HelpMicroButton:SetPoint("BOTTOMLEFT", MainMenuMicroButton, "BOTTOMRIGHT", spacing, 0)
    end)

    UpdateMicroButtons()
end


local function moveBagBar()
    --Bag Bar
    MainMenuBarBackpackButton:SetParent(JadeUIButtonParent)
    --MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", JadeUI.g13MainBar, "BOTTOM", 293, 2) --Accurate to actual bag bar
    moveBlizzardFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", "BOTTOM", 292, 3, JadeUI.g13MainBar) --Better Fitting

    if not GetCVarBool("showKeyring") then
        SetCVar("showKeyring", 1)
    end
    KeyRingButton:SetParent(JadeUIButtonParent)
    --KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -5, -1) --Accurate to actual bag bar
    moveBlizzardFrame(KeyRingButton, "RIGHT", "LEFT", -5, -1, CharacterBag3Slot) --Better Fitting

    for i = 0, 3 do
        _G["CharacterBag" .. i .. "Slot"]:SetParent(JadeUIButtonParent)
    end

end


local function moveActionBars()
    --Main Action Bar
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetParent(JadeUIButtonParent)
        _G["ActionButton" .. i]:SetFrameLevel(JadeUIButtonParent:GetFrameLevel() + 1)
    end
    moveBlizzardFrame(ActionButton1, "CENTER", "CENTER", -127, 2, JadeUIBar)

    --Bottom Left Action Bar
    MultiBarBottomLeft:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomLeft, "BOTTOMLEFT", "TOPLEFT", 0, 7)

    --Bottom Right Action Bar
    MultiBarBottomRight:SetParent(JadeUIButtonParent)
    moveBlizzardFrame(MultiBarBottomRight, "TOPLEFT", "BOTTOMLEFT", 42, -47)

    --Bottom Right Action Bar Second Row
    moveBlizzardFrame(MultiBarBottomRightButton7, "TOPLEFT", "BOTTOMLEFT", 0, -7, MultiBarBottomRightButton1)

end

local function movePetBar()
    PetActionBarFrame:SetParent(JadeUIButtonParent)
    PetActionBarFrame:SetScale(0.7)
    moveBlizzardFrame(PetActionBarFrame, "BOTTOM", "TOP", 33, -44, JadeUIBarTopArtPanel)
end

local function hideButtons()
    --Main Action Bar
    for i = 8, 12 do
        hideBlizzardFrame(_G["ActionButton" .. i])
        hideBlizzardFrame(_G["MultiBarBottomLeftButton" .. i])
    end

    --Bottom Right Action Bar
    hideBlizzardFrame(MultiBarBottomRightButton6)
    hideBlizzardFrame(MultiBarBottomRightButton7)
    hideBlizzardFrame(MultiBarBottomRightButton11)
    hideBlizzardFrame(MultiBarBottomRightButton12)
end

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
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    moveBlizzardFrame(CastingBarFrame,"BOTTOM", "BOTTOM", 0, 248) --Casting Bar
    moveBlizzardFrame(FramerateLabel, "BOTTOM", "BOTTOM", -190, 85) --Framerate
    moveBlizzardFrame(DurabilityFrame, "LEFT", "RIGHT", 0, 23, JadeUIBarTopArtPanel) --Durability Frame

    verticalMultiBarFix()
    if JadeUIDB.moveUnitFrames then JadeUI.moveUnitFramesFunc() end --Unit Frames/ff
    JadeUI.MinimapScaleFunc() --Minimap Scale. Needs to be above Minimap since Minimap includes scale calcs.
    if JadeUIDB.moveMinimap then JadeUI.MoveMinimapFunc() end --Minimap

    if JadeUI.isVanilla then 
        moveBlizzardFrame(TutorialFrameParent,"BOTTOM", "BOTTOM", 0, 300) --Tutorial Frame
    end
end

--Move Blizzard Bars
function JadeUI.blizzBarMove()

    --Move Bars
    moveMicroMenu()
    moveBagBar()
    moveActionBars()
    hideButtons()
    if JadeUIDB.hideKeybinds then JadeUI.HideKeybinds() end
    hideBlizzardFrame(MainMenuBar)
    MainMenuBar.IsShown = function() return true end --Pretend that MainMenuBar is shown so blizz code is happy (https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/ActionBarController.lua#L163)

    local forms = GetNumShapeshiftForms()
    if forms > 0 then
        moveBlizzardFrame(StanceBarFrame, "BOTTOMLEFT", "TOPLEFT", 133, -120, JadeUIBarTopArtPanel)
    end
    movePetBar()

    --Other Variables
    if stanceBarHide then
        StanceBarFrame:Hide()
    end
end


--Fix Bartender so the two bottom buttons go below the menu/bag
function JadeUI.bartenderFix()
    BT4Button54:SetFrameLevel(1)
    BT4Button58:SetFrameLevel(1)

    if stanceBarHide then
        BT4BarStanceBar:Hide()
    end
end








