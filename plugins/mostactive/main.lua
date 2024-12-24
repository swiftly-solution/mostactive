AddEventHandler("OnPluginStart", function(event)
    db = Database("mostactive")
    if not db:IsConnected() then return end

    db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name"))):Create({
        name = "string|max:128",
        steamid = "string|max:128|unique",
        connected_time = "integer|default:0"
    }):Execute()

    local cmds = config:Fetch("mostactive.hours_commands")
    for i=1,#cmds do
        commands:Register(cmds[i], HoursCommand)
    end
end)

AddEventHandler("OnPlayerSpawn", function(event)
    if not db:IsConnected() then return end
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    if player:IsFirstSpawn() then
        db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name"))):Select({}):Where("steamid", "=", tostring(player:GetSteamID()))
            :Execute(function (err, result)
                if #result == 0 then
                    if not player:CBasePlayerController():IsValid() then return end
                    db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name")))
                        :Insert({ name = player:CBasePlayerController().PlayerName, steamid = tostring(player:GetSteamID()) }):Execute()
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

    db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name"))):Select({}):Where("steamid", "=", tostring(player:GetSteamID()))
        :Execute(function (err, result)
            local connected_time = 0
            if #result > 0 then
                connected_time = result[1].connected_time or 0
            end
            player:SetVar("connected_time", connected_time)
        end)
end)

AddEventHandler("OnClientDisconnect", function(event, playerid)
    if not db:IsConnected() then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    if player:GetVar("connected_time") == nil then return end

    db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name")))
        :Update({ connected_time = player:GetVar("connected_time") + player:GetConnectedTime() })
        :Where("steamid", "=", tostring(player:GetSteamID())):Execute()
end)
