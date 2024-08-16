extends CharacterBody3D

var isCaptured = true;

@export var mouse_sensitivity = 0.002
@onready var camera_3d = $Head/Camera3D

@export var player_id := 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)
		
@export var custom_velocity := Vector3.ZERO:
	set(new_velocity):
		custom_velocity = new_velocity
		velocity = custom_velocity
		move_and_slide()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if multiplayer.get_unique_id() == player_id:
		camera_3d.make_current()
	else:
		camera_3d.current = false


func _apply_movement_from_input(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = %InputSynchronizer.input_direction
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("Escape"):
		isCaptured = !isCaptured
	
	if isCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	if event is InputEventMouseMotion and isCaptured:
		$Head.rotate_x(-event.relative.y * mouse_sensitivity)
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-45), deg_to_rad(45))
		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
