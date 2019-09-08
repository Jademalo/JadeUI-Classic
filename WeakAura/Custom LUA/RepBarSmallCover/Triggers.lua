PLAYER_ENTERING_WORLD, UPDATE_FACTION

function()
    if UnitLevel("player") < GetMaxPlayerLevel() and GetWatchedFactionInfo() then
        return true
    end
end
