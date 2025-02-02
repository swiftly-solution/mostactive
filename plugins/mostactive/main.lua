AddEventHandler("OnPluginStart", function(event)
    db = Database("mostactive")
    if not db:IsConnected() then return end

    db:QueryBuilder():Table(tostring(config:Fetch("mostactive.table_name"))):Create({
        name = "string|max:128",
        steamid = "string|max:128|unique",
        hours_t = "integer|default:0",
        hours_ct = "integer|default:0",
        hours_spec = "integer|default:0",
        hours_total = "integer|default:0"
    }):Execute()

    local cmds = config:Fetch("mostactive.hours_commands")
    for i=1,#cmds do
        commands:Register(cmds[i], HoursCommand)
    end
    RegisterMenus()

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

AddEventHandler("OnPostPlayerTeam", function (event)
    local player = GetPlayer(event:GetInt("userid"))
    if event:GetInt("team") == 1 then
        player:CBaseEntity().TeamNum = 1
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
            local hours_t = 0
            local hours_ct = 0
            local hours_spec = 0
            local hours_total = 0
            if #result > 0 then
                hours_t = result[1].hours_t or 0
                hours_ct = result[1].hours_ct or 0
                hours_spec = result[1].hours_spec or 0
                hours_total = result[1].hours_total or 0
            end
            player:SetVar("hours_t", hours_t)
            player:SetVar("hours_ct", hours_ct)
            player:SetVar("hours_spec", hours_spec)
            player:SetVar("hours_total", hours_total)
        end)
end)