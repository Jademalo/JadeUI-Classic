--------------------------------------------
--Load all of the other relevant WeakAuras
--------------------------------------------
local mouseoverSmall = WeakAuras.GetRegion("MouseoverSmall")
local repTextSmall = WeakAuras.GetRegion("RepBarTextSmall")



--------------------------------------------
--Set scripts on Mouseover
--------------------------------------------
if not blizzXPBar then
    mouseoverSmall:SetScript("OnEnter", function()

        setFramesMain("MEDIUM")
        setFramesSmall("MEDIUM")

        if repTextSmall.subRegions[3] then
            repTextSmall.subRegions[3]:Show()
        end

    end)

    mouseoverSmall:SetScript("OnLeave", function()

        setFramesMain("BACKGROUND")
        setFramesSmall("BACKGROUND")

        if repTextSmall.subRegions[3] then
            repTextSmall.subRegions[3]:Hide()
        end

    end)
end
