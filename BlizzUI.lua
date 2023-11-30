--------------------------------------------
--Variables
--------------------------------------------
local name, JadeUI = ...


--------------------------------------------
--Functions to move basic Blizzard Frames
--------------------------------------------
local function moveUnitFramesFunc()
    --Player Frame
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrame:GetParent(), "BOTTOM", - 163, 200)
    PlayerFrame.SetPoint = function()end

    --Target Frame
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrame:GetParent(), "BOTTOM", 162, 200)
    TargetFrame.SetPoint = function()end

    if not JadeUI.isVanilla then
        --Focus Frame
        FocusFrame:ClearAllPoints()
        FocusFrame:SetPoint("BOTTOMLEFT", FocusFrame:GetParent(), "BOTTOM", - 163, 250)
        FocusFrame.SetPoint = function()end
    end
end


local function moveMinimapFunc()
    --Minimap
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("BOTTOMRIGHT", MinimapCluster:GetParent(), "BOTTOMRIGHT", 0, 0)
    MinimapCluster.SetPoint = function()end

    --Buff Bar
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - 13, - 13)
    BuffFrame.SetPoint = function()end
end


local function minimapScaleFunc()
    if minimapScale ~= 1 then
        MinimapCluster:SetScale(minimapScale)

        if not moveMinimap then
            local buffOffset = (MinimapCluster:GetWidth() * minimapScale) + 8

            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint("TOPRIGHT", BuffFrame:GetParent(), "TOPRIGHT", - buffOffset, - 13)
            BuffFrame.SetPoint = function()end
        end
    end
end


local function moveCastingBar()
    --Casting Bar
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", CastingBarFrame:GetParent(), "BOTTOM", 0, 248)
    CastingBarFrame.SetPoint = function()end
end


local function moveTutorialFrame()
    --Tutorial Frame
    TutorialFrameParent:ClearAllPoints()
    TutorialFrameParent:SetPoint("BOTTOM", TutorialFrameParent:GetParent(), "BOTTOM", 0, 300)
    TutorialFrameParent.SetPoint = function()end
end



local function moveFramerateLabel()
    FramerateLabel:SetPoint("BOTTOM", FramerateLabel:GetParent(), "BOTTOM", - 190, 85)
end


--------------------------------------------
--Core functions to apply changes
--------------------------------------------
--Move various Blizzard frames
function JadeUI.blizzUIMove()
    --if moveUnitFrames then
        moveUnitFramesFunc()
    --end

    --if moveMinimap then
        moveMinimapFunc()
    --end

    if JadeUI.isVanilla then
        moveTutorialFrame()
    end

    --minimapScaleFunc()
    moveCastingBar()
    moveFramerateLabel()
end


--Move Blizzard Bars
function JadeUI.blizzBarMove()
    --Move Bars
    moveMicroMenu()
    moveBagBar()
    moveActionBars()
    hideButtons()

    if blizzXPBar then
        moveBlizzXPBar()
    end

    local forms = GetNumShapeshiftForms()
    if forms > 0 then
        moveStanceBar()
    end
    if UnitExists("pet") then
        movePetBar()
    end

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








