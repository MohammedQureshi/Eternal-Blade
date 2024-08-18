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
	if multiplayer.is_server() and not player.isPaused:
		print("JUMP")
		player.do_jump = true

@rpc("call_local")
func pause():
	if multiplayer.is_server():
		player.isPaused = !player.isPaused
		print(player.isPaused)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if player.isPaused else Input.MOUSE_MODE_CAPTURED)
