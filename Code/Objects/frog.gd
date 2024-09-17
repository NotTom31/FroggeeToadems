extends RigidBody2D

var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 800  # Cap how fast we can throw the frogs
var max_rotation_angle = deg_to_rad(40)  # Max rotation of 40 degrees (in radians)
var rotation_speed = 3  # How fast the rotation should interpolate (adjust for smoothness)

var original_layer: int
var original_mask: int

func _ready() -> void:
	# Store the original values
	original_layer = collision_layer

func _process(delta: float) -> void:
	if selected:
		follow_mouse(delta)
		disable_gravity()
	else:
		enable_gravity()

func follow_mouse(delta: float) -> void:
	# Calculate the velocity of the mouse movement
	var mouse_position = get_global_mouse_position()
	mouse_velocity = (mouse_position - position) / delta  # Calculate velocity
	position = mouse_position

	# Gradually apply rotation based on horizontal velocity
	apply_rotation_based_on_velocity(delta)

func apply_rotation_based_on_velocity(delta: float) -> void:
	# Get the horizontal speed (mouse_velocity.x)
	var horizontal_speed = mouse_velocity.x
	
	# Calculate the target rotation angle based on speed
	var target_rotation_angle = clamp(horizontal_speed / max_velocity * max_rotation_angle, -max_rotation_angle, max_rotation_angle)
	
	# Gradually interpolate current rotation towards the target rotation
	rotation = lerp(rotation, target_rotation_angle, rotation_speed * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = true
			collision_layer = 0
			linear_velocity = Vector2.ZERO  # Stop any current movement when picked up
			angular_velocity = 0  # Stop rotation if needed
		else:
			# Check if the release event happened while the object was selected
			if selected:
				selected = false
				collision_layer = original_layer
				mouse_velocity = mouse_velocity.limit_length(max_velocity)
				linear_velocity = mouse_velocity  # Apply mouse velocity to the RigidBody2D

func disable_gravity() -> void:
	gravity_scale = 0

func enable_gravity() -> void:
	gravity_scale = 1
