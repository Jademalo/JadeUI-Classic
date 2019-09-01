--------------------------------------------
--Move various Blizzard frames
--------------------------------------------
if moveUnitFrames then
    moveUnitFramesFunc()
end

if moveMinimap then
    moveMinimapFunc()
end

minimapScaleFunc()
moveCastingBar()
moveFramerateLabel()

if isClassic then
    moveTutorialFrame()
end



--------------------------------------------
--Move Blizzard Bars if not using Bartender
--------------------------------------------
C_Timer.After(0.1, function()
        if not IsAddOnLoaded("Bartender4") then

            --Move Bars
            if blizzXPBar then
                moveBlizzXPBar()
            end


            forms = GetNumShapeshiftForms()
            if forms > 0 then
                moveStanceBar()
            end

            --if UnitExists("pet") then
            --    movePetBar()
            --end


            moveMicroMenu()
            moveBagBar()
            moveActionBars()
            hideButtons()


            if stanceBarHide then
                StanceBarFrame:Hide()
            end


            --Hide Blizzard Bar
            MainMenuBar:Hide()

        end
end)



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
