extends Node

const SERVER_PORT = 8080
var SERVER_IP = "127.0.0.1"

var player_scene = preload("res://Component/Player/Player.tscn")
var is_multiplayer = false
var is_host = false
var client_peer
var server_peer
var _players_spawn_node

func host_game():
	print("Hosting game")
	
	if not multiplayer.get_peers().is_empty():
		print("Server is already running on this machine.")
		return
		
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player_from_game)
	
	_add_player_to_game(1)
	
func join_hosted_game():
	print("Joined hosted game")
	
	client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = player_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)
	
func disconnect_player():
	if is_multiplayer:
		if is_host:
			server_peer.close()
		else:
			client_peer.close()
			
		is_multiplayer = false
		is_host = false
		SERVER_IP = ""

func _del_player_from_game(id: int):
	print("Player %s left the game" % id)
	if not _players_spawn_node.has_node(str(id)):
		return 
	_players_spawn_node.get_node(str(id)).queue_free()

