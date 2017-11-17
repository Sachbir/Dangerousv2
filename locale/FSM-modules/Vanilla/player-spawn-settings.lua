-- Script on player creation
script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player_creation_inventory(player)
  chart_area(player)
  welcome_message(player)
  -- silo_script.gui_init(player)
end)

-- Script on player respawn
script.on_event(defines.events.on_player_respawned, function(event)
  local player = game.players[event.player_index]
  player_respawn_inventory(player)  
end)

-- List of items to give a player on creation
-- @param player
function player_creation_inventory(player)
  player.insert{name="iron-plate", count=4}
  player.insert{name="iron-axe", count=1}  
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
  player.insert{name="burner-mining-drill", count = 1}
  player.insert{name="stone-furnace", count = 1}
end

-- List of items to give a player on respawn
-- @param player
function player_respawn_inventory(player)
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
end

-- Charts an area around a player
-- @param player
function chart_area(player)
  player.force.chart(player.surface, {{player.position.x - 200, player.position.y - 200}, {player.position.x + 200, player.position.y + 200}})
end

function welcome_message(player)
  player.print({"msg-intro1"})
  player.print({"msg-intro2"})
end