extends Control

func _on_host_game_pressed():
	MultiplayerManager.is_multiplayer = true
	MultiplayerManager.is_host = true
	get_tree().change_scene_to_file("res://Client/GameScene.tscn")

func _on_play_with_friends_pressed():
	get_tree().change_scene_to_file("res://UserInterface/Menu/JoinMenu/JoinMenu.tscn")
