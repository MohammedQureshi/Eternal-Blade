extends Node3D

var frames_per_second
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if MultiplayerManager.is_multiplayer:
		if MultiplayerManager.is_host:
			MultiplayerManager.host_game()
		else: 
			MultiplayerManager.join_hosted_game()

func _process(delta):
	var frames_per_second = int(1.0 / delta)

func _input(event):
	pass
