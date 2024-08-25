extends MultiplayerSynchronizer

@onready var player = $".."
@onready var pause_screen: Control = get_node("/root/Game/PauseScreen")

var input_direction

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")

func _physics_process(delta):
	if not player.is_pause:
		input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	
func _process(delta):
	#Per multiplayer authority which is multiplayer.get_unique_id
	if Input.is_action_just_pressed("Jump"):
		jump.rpc()
	if Input.is_action_just_pressed("Escape"):
		print("Hello" + str(multiplayer.get_unique_id()))
		toggle_pause()

@rpc("call_local")
func jump():
	if multiplayer.is_server() and not player.is_pause:
		print("MultiplayerID: " + str(multiplayer.get_unique_id()))
		print("JUMP")
		player.do_jump = true

func toggle_pause():
	if multiplayer.get_unique_id() == player.player_id:
		print("MultiplayerID: " + str(multiplayer.get_unique_id()))
		player.is_pause = !player.is_pause
		if player.is_pause == true:
			pause_screen.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			pause_screen.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
