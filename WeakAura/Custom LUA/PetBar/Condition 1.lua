if IsAddOnLoaded("Bartender4") then
    local petBar = aura_env.region
    petBar:SetParent(BT4PetButton1)
    petBar:SetPoint("LEFT", BT4PetButton1, "LEFT", - 36, 13)
    petBar:SetFrameLevel(BT4PetButton1:GetFrameLevel() - 1)
end

-- -132 from Bartender to maake the buttons line up properly
