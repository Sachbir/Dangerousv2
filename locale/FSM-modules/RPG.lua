-- RPG
-- 
-- Author: Sachbir Dhanota 
-- Github: https://github.com/Sachbir
-- ============================================================= --

require("locale/FSM-core/util/Player_Data")
require("locale/FSM-core/util/Time")

RPG = {}
RPG.levels = {}

-- Here I define the time required to reach each level
-- max_level:       The max level acquirable
-- time is measured in hours
local max_level = 10
for i=1,max_level do
    local level_title = "level_" .. i
    RPG.levels[level_title] = { time = 2^(i-1) }
end 

function RPG.update_level(player)
    Player_Data.register(player)
    for i=10,1,-1 do
        local level_title = "level_" .. i
        if Time.tick_to_hour(player.online_time) > RPG.levels[level_title].time then
            Player_Data.data[player.name].level = i 
            break
        end 
    end
end 