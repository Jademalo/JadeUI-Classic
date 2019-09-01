--Trigger 1
PLAYER_ENTERING_WORLD, UPDATE_EXHAUSTION, PLAYER_XP_UPDATE

function()
    if UnitLevel("player") < GetMaxPlayerLevel() and not blizzXPBar then
        return true
    end
end


--Duration Info
function()
    local restedXP = GetXPExhaustion()
    local cur = UnitXP("player")
    local max = UnitXPMax("player")

    if restedXP then
        return min(cur + restedXP, max), UnitXPMax("player"), true
    end
end


--Trigger 2
PLAYER_XP_UPDATE

function(event, arg1, arg2, ...)
    if event == "PLAYER_XP_UPDATE" then
        return true
    end
end
