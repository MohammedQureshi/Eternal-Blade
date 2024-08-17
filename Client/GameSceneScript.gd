extends Node3D

var frames_per_second
var isCaptured = true;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if MultiplayerManager.is_multiplayer:
		if MultiplayerManager.is_host:
			MultiplayerManager.host_game()
		else: 
			MultiplayerManager.join_hosted_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var frames_per_second = int(1.0 / delta)
	DebugManager.debug.add_property("FramesPerSecond", frames_per_second, 2)

func _input(event):
	DebugManager.debug.add_property("CapturedState", isCaptured, 1)
	if Input.is_action_just_pressed("Escape"):
		isCaptured = !isCaptured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if isCaptured else Input.MOUSE_MODE_VISIBLE)

