extends MultiplayerSynchronizer

var input_direction

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")

func _physics_process(delta):
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	
func _process(delta):
	pass
