--Trigger 1
PLAYER_XP_UPDATE, PLAYER_ENTERING_WORLD, UPDATE_FACTION

function()
    local retVal = GetXPExhaustion()
    if not retVal and UnitLevel("player") < GetMaxPlayerLevel() and not blizzXPBar then
        return true
    end
end


--Trigger 2
PLAYER_ENTERING_WORLD, UPDATE_EXHAUSTION, PLAYER_XP_UPDATE

function()
    local retVal = GetXPExhaustion()
    if retVal and UnitLevel("player") < GetMaxPlayerLevel() and not blizzXPBar then
        return true
    end
end
