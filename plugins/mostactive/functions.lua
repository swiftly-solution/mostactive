function SaveTimer()
    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i - 1)
        if player and player:GetVar("connected_time") then
            if not player:GetVar("called_once") then
                db:Query(string.format(
                "UPDATE `%s` SET connected_time = connected_time + %d WHERE steamid = '%s' LIMIT 1",
                config:Fetch("mostactive.table_name"), player:GetConnectedTime(),
                tostring(player:GetSteamID())))
                player:SetVar("called_once", true)
            else
                db:Query(string.format(
                "UPDATE `%s` SET connected_time = connected_time + %d WHERE steamid = '%s' LIMIT 1",
                config:Fetch("mostactive.table_name"), player:GetConnectedTime() - player:GetVar("connected_time"),
                tostring(player:GetSteamID())))
            end
            player:SetVar("connected_time", player:GetConnectedTime())
        end
    end
end
