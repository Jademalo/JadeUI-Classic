PLAYER_ENTERING_WORLD, UPDATE_SHAPESHIFT_FORMS

function()

    local forms = GetNumShapeshiftForms()
    aura_env.stanceButCount = forms

    if forms > 0 then
        return true
    end

end


--Texture Info
function()
    if aura_env.stanceButCount == 6 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar6]]
    elseif aura_env.stanceButCount == 5 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar5]]
    elseif aura_env.stanceButCount == 4 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar4]]
    elseif aura_env.stanceButCount == 3 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar3]]
    elseif aura_env.stanceButCount == 2 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar2]]
    elseif aura_env.stanceButCount == 1 then
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar1]]
    else
        return [[Interface\Media\background\G13Classic\StanceBar\StanceBar6]]
    end
end
