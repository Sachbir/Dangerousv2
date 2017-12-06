-- Logger
-- Creates a log of server data 
-- Author: Sachbir Dhanota 
-- Github: https://github.com/Sachbir
-- ============================================================= --

-- INCOMPLETE: Does not yet work
-- error: line 36 "attempt to index "data", a nil value"

GUI = require("locale/FSM-core/util/GUI")

Logger = {}
Logger.data = {}
Logger.data.players = {}

script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.players[event.player_index]
    if player.admin == true then
        Logger.logger_button(player)
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "logger_btn" then
        Logger.log_data(player)
    end
end)

function Logger.logger_button(player)
    player.gui.top.add { type = "button", name = "logger_btn", caption = "Log Data" }
end 

function Logger.log_data(player)
    local output = "Log = {}\nLog.Player_Data = {}\n"
    for i,list_player in pairs(game.players) do
        if Player_Data.data[list_player.name] == nil then
            Player_Data.register(list_player)
        end
        output = output .. Logger.player_data_entry(list_player)
    end
end

function Logger.player_data_entry(player)
    local entry = "Log.Player_Data[player.name] = {\n"
    for stat,value in pairs(Player_Data.data[player.name]) do
        entry = entry .. stat .. " = " .. value .. ",\n"
    end
end