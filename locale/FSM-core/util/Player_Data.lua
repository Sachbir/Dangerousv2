-- Player Data
-- 
-- Author: Sachbir Dhanota
-- Github: https://github.com/Sachbir
-- ============================================================= --

-- Import logged data once implemented

Player_Data = {}
Player_Data.data = {}

function Player_Data.register(player)
    if Player_Data.data[player.name] == nil then
        Player_Data.data[player.name] = {
            games_played = 1, 
            logged_time = 0, 
            level = 0, 
            perm_decon = 0, 
            perm_moderate = 0,
            perm_tile = 0, 
            crafting_speed_modifier = 0, 
            mining_speed_modifier = 0, 
            reach_distance_bonus = 0, 
            running_speed_modifier = 0, 
        }
    end
end 