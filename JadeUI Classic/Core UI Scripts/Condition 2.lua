--Move various Blizzard frames
blizzUIMove()

--Move Blizzard Bars if not using Bartender
if not IsAddOnLoaded("Bartender4") then
    preventActionBarMovement() --Disable Blizzard dynamic UI positioning
    blizzBarMove() --Move the Blizzard Action Bars
    MainMenuBar:Hide() --Hide Blizzard Main Bar
else
    bartenderFix() --Fix some issues with Bartender
end
