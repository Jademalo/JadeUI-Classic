--------------------------------------------
--Move various Blizzard frames
--------------------------------------------
if moveUnitFrames then
    moveUnitFramesFunc()
end

if moveMinimap then
    moveMinimapFunc()
end

if isClassic then
    moveTutorialFrame()
end

minimapScaleFunc()
moveCastingBar()
moveFramerateLabel()



--------------------------------------------
--Move Blizzard Bars if not using Bartender
--------------------------------------------
if not IsAddOnLoaded("Bartender4") then
    C_Timer.After(0.3, function()

        --Move Bars
        moveMicroMenu()
        moveBagBar()
        moveActionBars()
        hideButtons()
        if blizzXPBar then
            moveBlizzXPBar()
        end

        --Hide Blizzard Bar
        MainMenuBar:Hide()

        --Move Stance and Pet Bars
        local forms = GetNumShapeshiftForms()
        if forms > 0 then
            moveStanceBar()
        end
        if UnitExists("pet") then
            movePetBar()
        end

        --Move action bars again to prevent issues
        --moveActionBars()

        --Other Variables
        if stanceBarHide then
            StanceBarFrame:Hide()
        end

    end)
end



--------------------------------------------
--Fix Bartender so the two bottom buttons go below the menu/bag
--------------------------------------------
if IsAddOnLoaded("Bartender4") then

    BT4Button54:SetFrameLevel(1)
    BT4Button58:SetFrameLevel(1)

    if stanceBarHide then
        BT4BarStanceBar:Hide()
    end

end
