--- @param playerid number
---@param args table
---@param argc number
---@param silent boolean
---@param prefix string
function HoursCommand(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end

    ReplyToCommand(playerid, config:Fetch("mostactive.prefix"),
        FetchTranslation("mostactive.current_hours"):gsub("{HOURS}",
            string.format("%.2f", ((player:GetVar("connected_time") or 0) + player:GetConnectedTime()) / 3600)))
end
