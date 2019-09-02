--Trigger 1
PLAYER_LOGIN

function()
    return true
end


--Trigger 2
PLAYER_ENTERING_WORLD

function()
    return true
end


--Trigger 3
ACTIONBAR_SHOWGRID, ACTIONBAR_HIDEGRID

function(event, arg1, arg2, ...)
    if event == "ACTIONBAR_SHOWGRID" then
        return true
    end
end

function(event, arg1, arg2, ...)
    if event == "ACTIONBAR_HIDEGRID" then
        return true
    end
end


--Trigger 4
PET_BAR_UPDATE, UPDATE_FACTION

function()
    return true
end
