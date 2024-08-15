extends Control

const GAME_SCENE_PATH = "res://Client/GameScene.tscn"

func _on_join_server_pressed():
	MultiplayerManager.is_multiplayer = true
	MultiplayerManager.is_host = false
	MultiplayerManager.SERVER_IP = $MarginContainer/VBoxContainer/IPAddressInput.text
	get_tree().change_scene_to_file(GAME_SCENE_PATH)
