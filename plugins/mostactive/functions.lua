SetTimer(60000, function()
    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i - 1)
        if player and player:GetVar("connected_time") ~= nil and not player:IsFakeClient() then
            db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name")))
                :Update({ connected_time = player:GetVar("connected_time") + player:GetConnectedTime() })
                :Where("steamid", "=", tostring(player:GetSteamID())):Execute()
        end
    end
end)