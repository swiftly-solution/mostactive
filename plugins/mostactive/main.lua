AddEventHandler("OnPluginStart", function(event)
    db = Database("mostactive")

    db:Query(
        "CREATE TABLE IF NOT EXISTS `" ..
        config:Fetch("mostactive.table_name") ..
        "` (`name` varchar(128) NOT NULL, `steamid` varchar(128) NOT NULL, `connected_time` int(11) NOT NULL DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;",
        function(err, result)
            if #result > 0 then
                db:Query("ALTER TABLE `" ..
                    config:Fetch("mostactive.table_name") .. "` ADD UNIQUE KEY `steamid` (`steamid`);")
            end
        end)

    for i = 1, config:FetchArraySize("mostactive.hours_commands") do
        commands:Register(config:Fetch("mostactive.hours_commands[" .. (i - 1) .. "]"), HoursCommand)
    end

    SetTimeout(60000, SaveTimer)
end)

AddEventHandler("OnPlayerSpawn", function(event)
    if not db:IsConnected() then return end
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    if player:IsFirstSpawn() then
        db:Query(
            string.format("SELECT * FROM `%s` WHERE steamid = '%s' LIMIT 1", config:Fetch("mostactive.table_name"),
                tostring(player:GetSteamID())),
            function(err, result)
                if #result == 0 then
                    db:Query(string.format("INSERT IGNORE INTO `%s` (name, steamid) VALUES ('%s', '%s')",
                        config:Fetch("mostactive.table_name"), db:EscapeString(player:CBasePlayerController().PlayerName),
                        tostring(player:GetSteamID())))
                end
            end)
    end
end)

AddEventHandler("OnPlayerConnectFull", function(event)
    if not db:IsConnected() then return end
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    db:Query(
        string.format("SELECT * FROM `%s` WHERE steamid = '%s' LIMIT 1", config:Fetch("mostactive.table_name"),
            tostring(player:GetSteamID())),
        function(err, result)
            if #result > 0 then
                local connected_time = result[1]["connected_time"] or 0
                player:SetVar("connected_time", connected_time)
            end
        end)
end)

AddEventHandler("OnClientDisconnect", function(event, playerid)
    if not db:IsConnected() then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    db:Query(string.format("UPDATE `%s` set connected_time = connected_time + %d where steamid = '%s' limit 1",
        config:Fetch("mostactive.table_name"), player:GetConnectedTime() - player:GetVar("connected_time"),
        tostring(player:GetSteamID())))
end)
