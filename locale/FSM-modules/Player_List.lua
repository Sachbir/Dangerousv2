-- Player List
-- Creates a list of all online players as a sidepanel
-- Author: Sachbir Dhanota 
-- Github: https://github.com/Sachbir
-- ============================================================= --

Color = require("locale/FSM-core/util/Colors")
GUI = require("locale/FSM-core/util/GUI")
require("locale/FSM-modules/RPG")

local Owner = "UberJuice"
-- local Partners = {
--     "UberJuice",
--     "spaghetti335",
--     "DDDGamer",
--     "AngamaraOnline",
-- }

-- Defines "roles" to be treated uniquely in the player list
local Roles = {
    Owner = { tag = "Owner", },
    Admin = { tag = "Admin", }
}

-- When a player joins, create a player list button
script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.players[event.player_index]
    -- player_data_register(player) -- For later use with player data
    draw_player_list_button(player)
    draw_player_list_frame()
end)

-- When a player leaves, remove the player list button
script.on_event(defines.events.on_player_left_game, function(event)
    local player = game.players[event.player_index]
    if player.gui.top["player_list_btn"] ~= nil then
        player.gui.top["player_list_btn"].destroy()
    end
    if player.gui.left["player_list_frame"] ~= nil then
        player.gui.left["player_list_frame"].destroy()
    end 
    
end)

-- When the button is pressed, toggle the visibility of the player list
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.players[event.player_index]
    if event.element.name == "player_list_btn" then
        GUI.toggle_element(player.gui.left["player_list_frame"])
    end 
end)

function draw_player_list_button(player)
    if player.gui.top["player_list_btn"] == nil then
        player.gui.top.add{ name = "player_list_btn", type = "sprite-button", sprite = "item/power-armor-mk2" }
        player.gui.top.player_list_btn.style.minimal_width = 41
        player.gui.top.player_list_btn.style.minimal_height = 41        
    end 
end 

function draw_player_list_frame()
    for i,player in pairs(game.connected_players) do
        if player.gui.left["player_list_frame"] == nil then
            player.gui.left.add { type = "frame", name = "player_list_frame", direciton = "vertical" }
        else 
            player.gui.left.player_list_frame.clear()
        end
        if player.admin then
            player.gui.left["player_list_frame"].add { type = "table", name = "player_list_table", colspan = 5 }  
            player.gui.left["player_list_frame"].player_list_table.add { type = "label", caption = "Level", style = "caption_label_style" }
            player.gui.left["player_list_frame"].player_list_table.add { type = "label", name = "Player_Header", caption = "Players", style = "caption_label_style" }
            add_3_blanks(player)
            for j,list_player in pairs(game.connected_players) do
                RPG.update_level(list_player)
                add_to_player_list_for_admins(player, list_player)
            end
        else -- For non-admins
            player.gui.left["player_list_frame"].add { type = "table", name = "player_list_table", colspan = 2 }
            player.gui.left["player_list_frame"].player_list_table.add { type = "label", caption = "Level", style = "caption_label_style" }
            player.gui.left["player_list_frame"].player_list_table.add { type = "label", name = "Player_Header", caption = "Players", style = "caption_label_style" }
            for k,list_player in pairs(game.connected_players) do
                RPG.update_level(list_player)
                add_to_player_list(player, list_player)
            end
        end
    end
end 

-- Creates an entry in the player list for a given player
-- @param player        The player for whom the player list is drawn
-- @param list_player   The player being added to the list
function add_to_player_list(player, list_player)
    local player_list_table = player.gui.left.player_list_frame.player_list_table
    player_list_table.add { type = "label", caption = "[Level " .. global.Player_Data.data[list_player.name].level .. "]" }     
    if list_player.name == Owner then
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name .. " | Owner" }
    elseif list_player.admin then
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name .. " | Admin" }
    else
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name }        
    end
end

-- Creates an entry in the player list for a given player, but with added info for admins
-- @param player        The player for whom the player list is drawn
-- @param list_player   The player being added to the list
function add_to_player_list_for_admins(player, list_player)
    local player_list_table = player.gui.left.player_list_frame.player_list_table    
    player_list_table.add { type = "label", caption = "[Level " .. global.Player_Data.data[list_player.name].level .. "]" }     
    if list_player.name == Owner then
        add_label_to_table(player, list_player.name .. " | Owner")
        add_3_blanks(player)
    elseif list_player.admin then
        add_label_to_table(player, list_player.name .. " | Admin")
        add_3_blanks(player)
    else
        add_label_to_table(player, list_player.name)  
        add_sprite_to_table(player, list_player, "grenade")
        add_sprite_to_table(player, list_player, "cluster-grenade")
        add_sprite_to_table(player, list_player, "atomic-bomb") 
    end
end

--@param player     Player for whom the table is written
function add_label_to_table(player, data)
    player.gui.left.player_list_frame.player_list_table.add { type = "label", caption = data }
end

--@param player     Player for whom the table is written
function add_sprite_to_table(player, list_player, sprite_name)
    if list_player.get_item_count(sprite_name) > 0 then
        player.gui.left.player_list_frame.player_list_table.add { type = "sprite", sprite = "item/" .. sprite_name } 
    else 
        add_label_to_table(player, "")
    end 
end 

function add_3_blanks(player)
    add_label_to_table(player, "")
    add_label_to_table(player, "")
    add_label_to_table(player, "")
end

script.on_event(defines.events.on_tick, function(event)
    local cur_time = game.tick / 60 -- 3600
    local refresh_period = 1 -- in minutes
    if cur_time % refresh_period == 0 then
        draw_player_list_frame()
    end 
end)