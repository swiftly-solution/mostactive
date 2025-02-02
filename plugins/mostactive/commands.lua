--- @param playerid number
---@param args table
---@param argc number
---@param silent boolean
---@param prefix string
function HoursCommand(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end

    db:QueryBuilder():Table("mostactive"):Select({}):Where("steamid", "=", tostring(player:GetSteamID())):Execute(function(err, result)
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

        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "-------------------------------------")
        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "Hours CT: {red}" .. ComputePrettyTime(hours_ct))
        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "Hours T: {red}" .. ComputePrettyTime(hours_t))
        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "Hours SPEC: {red}" .. ComputePrettyTime(hours_spec))
        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "Total Hours: {red}" .. ComputePrettyTime(hours_total))
        ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), "-------------------------------------")
    end)
end


commands:Register("tophours", function (playerid, args, argsCount, silent, prefix)
    local player = GetPlayer(playerid)
    if not player or not player:IsValid() then return end

    local option = args[1]

    if argsCount == 0 then
        player:HideMenu()
        player:ShowMenu("top_menu")
    end

    if option == "1" then
        db:QueryBuilder():Table("mostactive"):Select({"hours_ct", "name"}):OrderBy({ hours_ct = "DESC" }):Limit(10):Execute(function (err, result)
            if #err > 0 then
                print("{RED} ERROR: ".. eerr)
            end
            local top_ct = {}
            for i = 1, #result do
                if (type(result[i])) == "table" then
                    local name = result[i]["name"]
                    local ore = tonumber(result[i]["hours_ct"] or 0)
                    local ore_formatted = ComputePrettyTime(ore)
                    table.insert(top_ct, { name .. " - " .. ore_formatted.."", "" })
                end
            end
            menus:RegisterTemporary(string.format("top_ct_%d", playerid), "Top - CT", "ADD8E6", top_ct)
            player:HideMenu()
            player:ShowMenu(string.format("top_ct_%d", playerid))
        end)
    elseif option == "2" then
        db:QueryBuilder():Table("mostactive"):Select({"hours_t", "name"}):OrderBy({ hours_t = "DESC" }):Limit(10):Execute(function (err, result)
            if #err > 0 then
                print("{RED} ERROR: ".. eerr)
            end
            local top_t = {}
            for i = 1, #result do
                if (type(result[i])) == "table" then
                    local name = result[i]["name"]
                    local ore = tonumber(result[i]["hours_t"] or 0)
                    local ore_formatted = ComputePrettyTime(ore)
                    table.insert(top_t, { name .. " - " .. ore_formatted.."", "" })
                end
            end
            menus:RegisterTemporary(string.format("top_t_%d", playerid), "Top - T", "ADD8E6", top_t)
            player:HideMenu()
            player:ShowMenu(string.format("top_t_%d", playerid))
        end)
    elseif option == "3" then
        db:QueryBuilder():Table("mostactive"):Select({"hours_spec", "name"}):OrderBy({ hours_spec = "DESC" }):Limit(10):Execute(function (err, result)
            if #err > 0 then
                print("{RED} ERROR: ".. eerr)
            end
            local top_spec = {}
            for i = 1, #result do
                if (type(result[i])) == "table" then
                    local name = result[i]["name"]
                    local ore = tonumber(result[i]["hours_spec"] or 0)
                    local ore_formatted = ComputePrettyTime(ore)
                    table.insert(top_spec, { name .. " - " .. ore_formatted.."", "" })
                end
            end
            menus:RegisterTemporary(string.format("top_spec_%d", playerid), "Top - Spec", "ADD8E6", top_spec)
            player:HideMenu()
            player:ShowMenu(string.format("top_spec_%d", playerid))
        end)
    elseif option == "4" then
        db:QueryBuilder():Table("mostactive"):Select({"hours_total", "name"}):OrderBy({ hours_total = "DESC" }):Limit(10):Execute(function (err, result)
            if #err > 0 then
                print("{RED} ERROR: ".. eerr)
            end
            local top_total = {}
            for i = 1, #result do
                if (type(result[i])) == "table" then
                    local name = result[i]["name"]
                    local ore = tonumber(result[i]["hours_total"] or 0)
                    local ore_formatted = ComputePrettyTime(ore)
                    table.insert(top_total, { name .. " - " .. ore_formatted.."", "" })
                end
            end
            menus:RegisterTemporary(string.format("top_total_%d", playerid), "Top - Total", "ADD8E6", top_total)
            player:HideMenu()
            player:ShowMenu(string.format("top_total_%d", playerid))
        end)
    end
        
end)