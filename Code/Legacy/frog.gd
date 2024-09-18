extends CharacterBody2D

@export var gravity := 980.0

var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 900  # Cap how fast we can throw the frogs
var max_rotation_angle = deg_to_rad(40) 
var rotation_speed = 3  # How fast the rotation should change

var original_layer: int
var original_mask: int

func _ready() -> void:
	original_layer = collision_layer

func _process(delta: float) -> void:
	if selected:
		follow_mouse(delta)
		disable_gravity()
	else:
		enable_gravity()

func follow_mouse(delta: float) -> void:
	# Calculate the velocity of the mouse
	var mouse_position = get_global_mouse_position()
	mouse_velocity = (mouse_position - position) / delta  # Calculate velocity
	position = mouse_position

	apply_rotation_based_on_velocity(delta)

func apply_rotation_based_on_velocity(delta: float) -> void:
	var horizontal_speed = mouse_velocity.x
	
	var target_rotation_angle = clamp(horizontal_speed / max_velocity * max_rotation_angle, -max_rotation_angle, max_rotation_angle)
	
	#interpolate current rotation to target rotation
	rotation = lerp(rotation, target_rotation_angle, rotation_speed * delta)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = true
			collision_layer = 0
			velocity = Vector2.ZERO
			#angular_velocity = 0  # Stop rotation
		else:
			selected = false
			collision_layer = original_layer
			mouse_velocity = mouse_velocity.limit_length(max_velocity)
			velocity = mouse_velocity  # Apply mouse velocity to the RigidBody2D

func disable_gravity() -> void:
	gravity = 0

func enable_gravity() -> void:
	gravity = 980.0

func _physics_process(delta: float):
	# Apply gravity to velocity
	velocity.y += gravity * delta
	# Move the character with the applied gravity
	move_and_slide()

func _on_mouse_exited() -> void:
	selected = false #failsafe
