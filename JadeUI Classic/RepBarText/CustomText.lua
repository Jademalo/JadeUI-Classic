function()

    --Check for Exalted
    if aura_env.standingID == 8 then
        return string.format("%s", aura_env.factionName)
    else
        return string.format("%s %s / %s", aura_env.factionName, aura_env.factionCur, aura_env.factionMax)
    end

end
