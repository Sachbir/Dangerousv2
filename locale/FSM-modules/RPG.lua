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

-- Here I modify the rate of leveling for testing purposes
-- modifier = 0.004
-- for i=1,max_level do 
--     local level_title = "level_" .. i
--     RPG.levels[level_title].time = RPG.levels[level_title].time * modifier
-- end 

function RPG.update_level(player)
    Player_Data.register(player)
    local temp_player_level = global.Player_Data.data[player.name].level
    for i=10,1,-1 do
        local level_title = "level_" .. i
        if Time.tick_to_hour(player.online_time) > RPG.levels[level_title].time then
            global.Player_Data.data[player.name].level = i 
            break
        end 
    end
    if temp_player_level < global.Player_Data.data[player.name].level then
        RPG.set_bonuses(player)
    end
end 

function RPG.set_bonuses(player)
    RPG.set_crafting_speed_modifier(player)
    RPG.set_mining_speed_modifier(player)
    RPG.set_running_speed_modifier(player)
end

function RPG.set_crafting_speed_modifier(player)
    local max_bonus = 1
    local increment = max_bonus / max_level
    global.Player_Data.data[player.name].crafting_speed_modifier = global.Player_Data.data[player.name].level * increment
    player.character_crafting_speed_modifier = global.Player_Data.data[player.name].crafting_speed_modifier
end

function RPG.set_mining_speed_modifier(player)
    local max_bonus = 1
    local increment = max_bonus / max_level
    global.Player_Data.data[player.name].mining_speed_modifier = global.Player_Data.data[player.name].level * increment
    player.character_mining_speed_modifier = global.Player_Data.data[player.name].mining_speed_modifier
end

function RPG.set_running_speed_modifier(player)
    local max_bonus = 1
    local increment = max_bonus / max_level
    global.Player_Data.data[player.name].running_speed_modifier = global.Player_Data.data[player.name].level * increment
    player.character_running_speed_modifier = global.Player_Data.data[player.name].running_speed_modifier
end