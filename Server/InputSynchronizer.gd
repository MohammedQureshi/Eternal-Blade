extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")

func _physics_process(delta):
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	
func _process(delta):
	if Input.is_action_just_pressed("Jump"):
		jump.rpc()
	if Input.is_action_just_pressed("Escape"):
		pause.rpc()

@rpc("call_local")
func jump():
	if multiplayer.is_server() and not player.is_pause:
		print("MultiplayerID: " + str(multiplayer.get_unique_id()))
		print("JUMP")
		player.do_jump = true

@rpc("call_local")
func pause():
	if multiplayer.is_server():
		print("MultiplayerID: " + str(multiplayer.get_unique_id()))
		player.is_pause = !player.is_pause
