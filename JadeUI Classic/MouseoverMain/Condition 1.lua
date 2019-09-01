--------------------------------------------
--Load all of the other relevant WeakAuras
--------------------------------------------
local mouseoverMain = WeakAuras.GetRegion("MouseoverMain")
local xpText = WeakAuras.GetRegion("XPBarTextMarker")
local repText = WeakAuras.GetRegion("RepBarText")
local xpCover = WeakAuras.GetRegion("XPBarCover")



--------------------------------------------
--Set scripts on Mouseover
--------------------------------------------
if not blizzXPBar then

    mouseoverMain:SetScript("OnEnter", function()

        setFramesMain("MEDIUM")

        if xpText.subRegions[1] then
            xpText.subRegions[1]:Show()
        end
        if repText.subRegions[1] then
            repText.subRegions[1]:Show()
        end

    end)

    mouseoverMain:SetScript("OnLeave", function()

        setFramesMain("BACKGROUND")

        if xpText.subRegions[1] then
            xpText.subRegions[1]:Hide()
        end
        if repText.subRegions[1] then
            repText.subRegions[1]:Hide()
        end

    end)

end

if blizzXPBar then

    local expEnterFuncOrig = MainMenuExpBar:GetScript("OnEnter")

    mouseoverMain:SetScript("OnEnter", function()

        expEnterFuncOrig(MainMenuExpBar)
        setFramesBlizz("MEDIUM")
        MainMenuBarOverlayFrame:SetFrameLevel(xpCover:GetFrameLevel() + 1)

    end)


    local expLeaveFuncOrig = MainMenuExpBar:GetScript("OnLeave")

    mouseoverMain:SetScript("OnLeave", function()

        expLeaveFuncOrig(MainMenuExpBar)
        setFramesBlizz("BACKGROUND")

    end)

end
