-- Moderator Panel
-- Collects a group of actions for moderator use
-- Author: Sachbir Dhanota 
-- Github: https://github.com/Sachbir
-- ============================================================= --

-- BUG: Panel loads in low and jumps up

GUI = require("locale/FSM-core/util/GUI")

script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.players[event.player_index]
    if player.admin then
        -- player_data_register(player) -- For later use with player data
        draw_mod_panel_btn(player)
    end
end)

script.on_event(defines.events.on_player_left_game, function(event)
    local player = game.players[event.player_index]
    -- player_data_register(player) -- For later use with player data
    if player.admin then
        if game.players[player.name].gui.top.mod_panel_btn then
            game.players[player.name].gui.top.mod_panel_btn.destroy()
        end
        if game.players[player.name].gui.center.mod_panel_frame then
            game.players[player.name].gui.center.mod_panel_frame.destroy()
        end
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    local player = game.players[event.player_index]
    if event.element.name == "mod_panel_btn" then
        toggle_mod_panel_frame(player)
    elseif event.element.name == "popup_creator_btn" then
        send_popup(player)
    elseif event.element.name == "popup_close" then
        game.players[player.name].gui.center.popup_message.destroy()
    elseif event.element.name == "popup_creator_title" then
        toggle_popup_creator(player)
    elseif event.element.name == "player_tracker_title" then
        toggle_player_tracker_panel(player)
    elseif event.element.name == "player_tracker_btn" then
        player_tracker_camera_set(player)
    elseif event.element.name == "zoom_in" then
        player_tracker_camera_zoom_in(player)
    elseif event.element.name == "zoom_out" then
        player_tracker_camera_zoom_out(player)
    end 
end)

function draw_mod_panel_btn(player)
    if game.players[player.name].gui.top.mod_panel_btn == nil then
        game.players[player.name].gui.top.add{type = "button", name = "mod_panel_btn", caption = "Moderator Panel"}
    end
end 

function toggle_mod_panel_frame(player)
    local mod_panel_frame = game.players[player.name].gui.center.mod_panel_frame
    if mod_panel_frame == nil then
        draw_mod_panel_frame(player)
    else
        mod_panel_frame.destroy()
    end
end

function draw_mod_panel_frame(player)
    local mod_panel_frame = game.players[player.name].gui.center.mod_panel_frame
    if mod_panel_frame == nil then
        game.players[player.name].gui.center.add{type = "frame", name = "mod_panel_frame", direction = "vertical"}
    else
        mod_panel_frame.clear()
    end
    local mod_panel_frame = game.players[player.name].gui.center.mod_panel_frame
    mod_panel_frame.add{type = "label", caption = "Moderator Panel", style = "caption_label_style"}
    -- Popup Creator
    mod_panel_frame.add{type = "frame", name = "popup_creator", direction = "vertical"}
    mod_panel_frame.popup_creator.add{type = "label", name = "popup_creator_title", caption = "Send a Popup", style = "caption_label_style"}
    -- Player Tracker
    mod_panel_frame.add{type = "frame", name = "player_tracker", direction = "vertical"}
    mod_panel_frame.player_tracker.add{type = "label", name = "player_tracker_title", caption = "Player Tracker", style = "caption_label_style"}
    -- Why can't I get players into the dropdown list? 
    -- local player_array = {}
    -- for j,player in pairs(game.connected_players) do
    --     table.insert(player_array,player.name)
    -- end
end 

-- Creates a popup on the recipient's screen
-- @param playername    name of the recipient 
-- @param message       message to display in popup (copyable)
function popup_message(playername,message)
    local gui_center = game.players[playername].gui.center
    if gui_center.popup_message then
        gui_center.popup_message.clear()
    else
        gui_center.add{type = "frame", name = "popup_message", direction = "vertical"}
    end
    gui_center.popup_message.add{type = "textfield", text = message}
    gui_center.popup_message.add{type = "button", name = "popup_close", caption = "close"}
end

-- Handles the send operation of a popup (whether or not it should go through)
-- @param player    LuaPlayer of the sender (not the recipient!)
function send_popup(player)
    local playername = game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.popup_receiver.text
    local message = game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.popup_message.text
    if playername == "" then
        game.players[player.name].print("Error: Missing Player Name")
    elseif game.players[playername] == nil then
        game.players[player.name].print("Error: Invalid Player Name")
    elseif message == "" then
        game.players[player.name].print("Error: No Message")            
    else
        popup_message(playername, message)
    end
    draw_mod_panel_frame(player)
end

-- Toggles the creation/destruction of the 'Popup Creator' window
-- @param player    LuaPlayer
function toggle_popup_creator(player)
    if game.players[player.name].gui.center.mod_panel_frame.popup_creator.table then
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.clear()
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.add{type = "label", name = "popup_creator_title", caption = "Send a Popup", style = "caption_label_style"}
    else
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.add{type = "table", name = "table", colspan = 2}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "label", caption = "Player Name"}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "textfield", name = "popup_receiver", caption = "Player Name"}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "label", caption = "Message"}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "textfield", name = "popup_message", caption = "Message"}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "label", caption = ""}
        game.players[player.name].gui.center.mod_panel_frame.popup_creator.table.add{type = "button", name = "popup_creator_btn", caption = "Send Popup"}
    end     
end

-- Toggles the creation/destruction of the 'Player Tracker' window
-- @param player    LuaPlayer
function toggle_player_tracker_panel(player)
    if game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table then
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.clear()
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.add{type = "label", name = "player_tracker_title", caption = "Player Tracker", style = "caption_label_style"}
        
    else
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.add{type = "table", name = "entry_table", colspan = 3}  
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.entry_table.add{type = "label", caption = "Player Name"}        
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.entry_table.add{type = "textfield", name = "camera_target"}
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.entry_table.add{type = "button", name = "player_tracker_btn", caption = "Player Name"}
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.add{type = "table", name = "camera_table", colspan = 2}          
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.add{type = "camera", name = "camera", position = game.players[player.name].position, zoom = 0.5}
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.style.minimal_width = 320
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.style.minimal_height = 320/1.41
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.add{type = "table", name = "zoom_table", colspan = 1}        
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.zoom_table.add{type = "button", name = "zoom_in", caption = "+"}                
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.zoom_table.add{type = "button", name = "zoom_out", caption = "-"}        
    end
end

function player_tracker_camera_set(observer)
    local observed = game.players[observer.name].gui.center.mod_panel_frame.player_tracker.entry_table.camera_target.text
    if observed == "" then
        game.players[observer.name].print("Error: Missing Player Name")
    elseif game.players[observed] == nil then
        game.players[observer.name].print("Error: Invalid Username")
    else
        game.players[observer.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.position = game.players[observed].position
    end
end

function player_tracker_camera_zoom_in(player)
    if game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom < 1.5 then
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom = game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom * 1.25
    end
end 

function player_tracker_camera_zoom_out(player)
    if game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom > 0.25 then
        game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom = game.players[player.name].gui.center.mod_panel_frame.player_tracker.camera_table.camera.zoom / 1.25
    end
end 