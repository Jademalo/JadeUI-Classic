--------------------------------------------
--Variables
--------------------------------------------
local addonName, JadeUI = ...
local textures = JadeUI.textures


--------------------------------------------
--Functions
--------------------------------------------
local function moveBlizzXPBar()
    --Exp Bar
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetParent(JadeUIBar)
    MainMenuExpBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 200)
    MainMenuExpBar:SetWidth(588)
    ExhaustionTick_OnEvent(_,"PLAYER_XP_UPDATE") --Force an event to run ExhaustionTick_OnEvent which handles setting the exhaustion tick relative to the xp bar - https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MainMenuBar.lua#L361

--[[     --Rested Exp - https://github.com/Gethe/wow-ui-source/blob/bc566bcfb0633aa29255dc1bb65b4bbed00967a4/Interface/FrameXML/MainMenuBar.lua#L361
    local etOnEvent = ExhaustionTick_OnEvent --Back up old OnEvent

    local function exhaustionSet() -- Function to calculate where the exhaustion level is and set them accordingly
        local exhaustionTickSet = max(((UnitXP("player") + GetXPExhaustion()) / UnitXPMax("player")) * MainMenuExpBar:GetWidth(), 0);
        ExhaustionTick:ClearAllPoints();
        ExhaustionTick:SetPoint("CENTER", MainMenuExpBar, "LEFT", exhaustionTickSet, 0);
        ExhaustionLevelFillBar:SetPoint("TOPRIGHT", MainMenuExpBar, "TOPLEFT", exhaustionTickSet, 0);
    end

    ExhaustionTick:SetScript("OnEvent", function() --Set OnEvent with the old script and then my new script on top of it
        MainMenuExpBar:SetWidth(588)
        etOnEvent()
        exhaustionSet()
    end)

    exhaustionSet() ]]

--[[     --Rested Exp - https://github.com/Gethe/wow-ui-source/blob/e03a7835c2da36f789e056b0a28c1a66cedd2f88/Interface/FrameXML/ExpBar.lua#L171
    local widthRatio = max((UnitXP("player") + GetXPExhaustion()) / UnitXPMax("player"), 0); --Percentage of rested XP
    local exhaustionTickSet = max(widthRatio * (ExhaustionTick:GetParent():GetWidth()), 0); --Exhaustion tick position basedon a percentage of the Exp bar width
    ExhaustionTick:ClearAllPoints();

    if ( exhaustionTickSet > ExhaustionTick:GetParent():GetWidth() ) then --If the tick would be beyond the width of the exp bar
        ExhaustionLevelFillBar:Hide();
    else
        ExhaustionTick:SetPoint("CENTER", ExhaustionTick:GetParent(), "LEFT", exhaustionTickSet, 2); --Exhaustion tick position

        ExhaustionLevelFillBar:Show();
        ExhaustionLevelFillBar:ClearAllPoints();
        ExhaustionLevelFillBar:SetPoint("TOPRIGHT", MainMenuExpBar, "TOPLEFT", exhaustionTickSet, 0) --Exhaustion level bar position
        ExhaustionLevelFillBar:SetWidth(exhaustionTickSet); --Exhaustion level bar width, using same value as the exhaustion tick
    end ]]

end


local function createRepBarCover()
    JadeUI.g13RepBar = JadeUIBar:CreateTexture("JadeUI Rep Bar Cover")
    JadeUI.g13RepBar:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 51)
    JadeUI.g13RepBar:SetTexture(textures.g13RepBarTexture)
    JadeUI.g13RepBar:SetDrawLayer("BACKGROUND", -2)
end

local function createMaxLevelCover()
    JadeUI.g13MaxCover = JadeUIBar:CreateTexture("JadeUI Max Level Cover")
    JadeUI.g13MaxCover:SetPoint("BOTTOM", JadeUIBar, "BOTTOM", 0, 43)
    JadeUI.g13MaxCover:SetTexture(textures.g13MaxCoverTexture)
    JadeUI.g13MaxCover:SetDrawLayer("BACKGROUND", -1)
end


local function replaceBlizzXPBarTexture()
    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()
    JadeUI.g13XPBar = JadeUIBar:CreateTexture("JadeUI XP Bar Cover")
    JadeUI.g13XPBar:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 4)
    JadeUI.g13XPBar:SetTexture(textures.g13XPBarTexture)
    JadeUI.g13XPBar:SetDrawLayer("BORDER", 7)
    JadeUI.g13XPBar:SetParent(MainMenuXPBarTexture0:GetParent())
end






function JadeUI.BlizzXPBarMove()
    moveBlizzXPBar()
    replaceBlizzXPBarTexture()
    createRepBarCover()
    createMaxLevelCover()
end

--Show/Hide the Max level cover depending on your level or tracked faction status
function JadeUI.showMaxCover()
    if UnitLevel("player") < GetMaxPlayerLevel() or GetWatchedFactionInfo() then
        JadeUI.g13MaxCover:Hide()
    else
        JadeUI.g13MaxCover:Show()
    end
 end