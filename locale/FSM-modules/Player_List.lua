-- Player List
-- Creates a list of all online players as a sidepanel
-- Author: Sachbir Dhanota 
-- Github: https://github.com/Sachbir
-- ============================================================= --

local Owner = "UberJuice"
local Partners = {
    "UberJuice",
    "spaghetti335",
    "DDDGamer",
    "AngamaraOnline",
}

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
        GUI.toggle_element("player_list_frame")
    end 
end)

function draw_player_list_button(player)
    if player.gui.top["player_list_btn"] == nil then
        player.gui.top.add{type = "button", name = "player_list_btn", caption = "Player List" }
    end 
end 

function draw_player_list_frame()
    for i,player in pairs(game.connected_players) do
        if player.gui.left["player_list_frame"] == nil then
            player.gui.left.add { type = "frame", name = "player_list_frame", direciton = "vertical" }
            player.gui.left["player_list_frame"].add { type = "table", name = "player_list_table", colspan = 1 }
        else 
            player.gui.left.player_list_frame.player_list_table.clear()
        end
        for j,list_player in pairs(game.connected_players) do
            -- Player_Rank.Update_Rank(item)    -- For future when Ranks are implemented
            add_to_player_list(player, list_player)
        end
    end
end 

-- Creates an entry in the player list for a given player
-- @param player        The player for whom the player list is drawn
-- @param list_player   The player being added to the list
function add_to_player_list(player, list_player)
    local player_list_table = player.gui.left.player_list_frame.player_list_table
    if list_player.name == Owner then
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name .. " | Owner" }
    elseif list_player.admin then
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name .. " | Admin" }
    else
        player_list_table.add { type = "label", name = list_player.name, caption = list_player.name }        
    end
end