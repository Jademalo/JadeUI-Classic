if IsAddOnLoaded("Bartender4") then
    local stanceBar = aura_env.region
    stanceBar:SetParent(BT4StanceButton1)
    stanceBar:SetPoint("LEFT", BT4StanceButton1, "LEFT", - 10, 13)
    stanceBar:SetFrameLevel(BT4StanceButton1:GetFrameLevel() - 1)
end

-- -115.5 from Bartender to maake the graphic clean
