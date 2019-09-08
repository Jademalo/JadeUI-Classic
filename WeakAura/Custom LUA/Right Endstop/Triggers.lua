PLAYER_ENTERING_WORLD

function()
    if not endstopType or endstopType < 3 then
        return true;
    end
end


--Texture Info
function()
    if endstopType == 1 then
        return [[Interface\MAINMENUBAR\UI-MainMenuBar-EndCap-Dwarf]]
    elseif endstopType == 2 then
        return [[Interface\MAINMENUBAR\UI-MainMenuBar-EndCap-Human]]
    end
end
