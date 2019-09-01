PLAYER_ENTERING_WORLD, UPDATE_EXHAUSTION, PLAYER_XP_UPDATE, UPDATE_FACTION

function()
    if UnitLevel("player") == GetMaxPlayerLevel() and not GetWatchedFactionInfo() then
        return true
    end
end
