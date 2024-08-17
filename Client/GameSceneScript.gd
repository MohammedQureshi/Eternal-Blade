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
	DebugManager.debug.add_property("FramesPerSecond", frames_per_second, 2)

func _input(event):
	DebugManager.debug.add_property("CapturedState", GlobalManager.isCaptured, 1)
	if Input.is_action_just_pressed("Escape"):
		GlobalManager.isCaptured = !GlobalManager.isCaptured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if GlobalManager.isCaptured else Input.MOUSE_MODE_VISIBLE)

