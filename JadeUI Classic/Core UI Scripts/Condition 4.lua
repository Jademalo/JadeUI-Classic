if not IsAddOnLoaded("Bartender4") then
    if isClassic then
        C_Timer.After(0.1, function()
            movePetBar()
            moveActionBars()
        end)
    end
end
