UPDATE_FACTION

function()
    if UnitLevel("player") == GetMaxPlayerLevel() and GetWatchedFactionInfo() and not blizzXPBar then
        return true
    end
end


--Duration Info
function()
    if GetWatchedFactionInfo() then

        --Check for the faction info
        local name, standingID, barMin, barMax, barValue, factionID = GetWatchedFactionInfo(factionIndex)

        --Check for Exalted
        if standingID == 8 then
            barMin, barMax, barValue = 0, 1, 1
        end

        --Adjust values to account for the true minimum
        barValue = barValue - barMin
        barMax = barMax - barMin

        --aura envs for display text
        aura_env.barColor = FACTION_BAR_COLORS[standingID]
        aura_env.factionCur, aura_env.factionMax = barValue, barMax
        aura_env.factionName = name
        aura_env.standingID = standingID

        return barValue, barMax, true

    end
end
