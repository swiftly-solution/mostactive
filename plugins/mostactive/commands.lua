--- @param playerid number
---@param args table
---@param argc number
---@param silent boolean
---@param prefix string
function HoursCommand(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end

    db:Query(
        string.format("select * from `%s` where steamid = '%s' limit 1", config:Fetch("mostactive.table_name"),
            tostring(player:GetSteamID())), function(err, result)
            if #err > 0 then
                return print("ERROR: " .. err)
            end

            if #result > 0 then
                ReplyToCommand(playerid, config:Fetch("mostactive.prefix"),
                    FetchTranslation("mostactive.current_hours"):gsub("{HOURS}",
                        string.format("%.2f", (result[1]["connected_time"] + player:GetConnectedTime()) / 3600)))
            else
                ReplyToCommand(playerid, config:Fetch("mostactive.prefix"), FetchTranslation("mostactive.no_entry"))
            end
        end)
end
