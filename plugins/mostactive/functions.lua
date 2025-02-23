function RegisterMenus()
    menus:Register("top_menu", "Hours - TOP", "ADD8E6", {
        { "Hours - CT", "sw_tophours 1"},
        { "Hours - T", "sw_tophours 2" },
        { "Hours - SPEC", "sw_tophours 3" },
        { "Hours - Total", "sw_tophours 4" },
    })
end
SetTimer(60000, function ()
    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i-1)
        if player and player:GetVar("hours_total") ~= nil and not player:IsFakeClient() and player:CBaseEntity():IsValid() then
            if player:CBaseEntity().TeamNum == Team.CT then
                print(player:CBaseEntity().TeamNum)
                db:QueryBuilder():Table("mostactive"):Update({ hours_ct = 60 + player:GetVar("hours_ct"), hours_total = player:GetVar("hours_total") + 60 }):Where("steamid", "=", tostring(player:GetSteamID())):Execute()
                player:SetVar("hours_ct", player:GetVar("hours_ct") + 60)
                player:SetVar("hours_total", player:GetVar("hours_total") + 60)
            elseif player:CBaseEntity().TeamNum == Team.T then
                db:QueryBuilder():Table("mostactive"):Update({ hours_t = 60 + player:GetVar("hours_t"), hours_total = player:GetVar("hours_total") + 60 }):Where("steamid", "=", tostring(player:GetSteamID())):Execute()
                player:SetVar("hours_t", player:GetVar("hours_t") + 60)
                player:SetVar("hours_total", player:GetVar("hours_total") + 60)
            elseif player:CBaseEntity().TeamNum == Team.Spectator then
                print(player:CBaseEntity().TeamNum)
                db:QueryBuilder():Table("mostactive"):Update({ hours_spec = player:GetVar("hours_spec") + 60, hours_total = player:GetVar("hours_total") + 60 }):Where("steamid", "=", tostring(player:GetSteamID())):Execute()
                player:SetVar("hours_spec", player:GetVar("hours_spec") + 60)
                player:SetVar("hours_total", player:GetVar("hours_total") + 60)
            end
        end
    end
end)

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    if hours > 0 then
        return hours .. " hours, " .. minutes .. " minutes"
    else
        return minutes .. " minutes"
    end
end
