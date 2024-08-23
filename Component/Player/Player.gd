extends CharacterBody3D

@export var mouse_sensitivity = 0.002
@onready var camera_3d = $Body/Head/Camera3D
@onready var body: MeshInstance3D = $Body
@onready var head: MeshInstance3D = $Body/Head


@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)
		
@export var custom_velocity := Vector3.ZERO:
	set(new_velocity):
		custom_velocity = new_velocity
		velocity = custom_velocity
		move_and_slide()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var do_jump = false
var is_pause = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == player_id:
		camera_3d.make_current()
		is_pause = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		camera_3d.current = false


func _apply_movement_from_input(delta):
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if is_pause else Input.MOUSE_MODE_CAPTURED)
	
	if is_pause:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false

	var input_dir = %InputSynchronizer.input_direction
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	
	direction = body.global_transform.basis * direction
	direction = direction.normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	
	if Input.is_action_just_pressed("ForceQuit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion and not is_pause:
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-45), deg_to_rad(45))
		body.rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	DebugManager.debug.add_property("Paused", is_pause, 1)
	DebugManager.debug.add_property("Jumping", do_jump, 3)
	DebugManager.debug.add_property("PlayerId", multiplayer.get_unique_id(), 4)
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
