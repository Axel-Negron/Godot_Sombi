extends CharacterBody3D
@onready var tp_camera_mount = $tp_camera_mount


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var running_speed = 1.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.1
var captured = true

func _unhandled_input(event):
	if Input.is_action_just_pressed("Quit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		captured = false
		pass

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	captured = true
	
func _input(event):
	if event is InputEventMouseMotion and captured:
		rotate_y(deg_to_rad(-event.relative.x *sensitivity))
		tp_camera_mount.rotate_x(deg_to_rad(-event.relative.y*sensitivity))
	if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			captured = true
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Running boost
	if Input.is_action_pressed("Run"):
		running_speed = 2
	else:
		running_speed = 1.0
		# Check if the camera is available
	# Check if the camera is available
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED*running_speed
		velocity.z = direction.z * SPEED*running_speed
		print(velocity.x)
		print(velocity.z)
		print(position.z)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#print(velocity.x)
		#print(velocity.z)
