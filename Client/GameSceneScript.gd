extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	if MultiplayerManager.is_multiplayer:
		if MultiplayerManager.is_host:
			MultiplayerManager.host_game()
		else: 
			MultiplayerManager.join_hosted_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
