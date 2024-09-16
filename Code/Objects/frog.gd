extends RigidBody2D

var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 500 # Cap how fast we can throw the frogs

# Called when the node enters the scene tree for the first time.
var original_layer: int
var original_mask: int

func _ready() -> void:
	# Store the original values
	original_layer = collision_layer
	#original_mask = collision_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = true
			print('Hello World!')
			collision_layer = 0
			linear_velocity = Vector2.ZERO  # Stop any current movement when picked up
			angular_velocity = 0  # Stop rotation if needed
		else:
			selected = false
			collision_layer = original_layer
			mouse_velocity = mouse_velocity.limit_length(max_velocity)
			linear_velocity = mouse_velocity  # Apply mouse velocity to the RigidBody2D

func disable_gravity() -> void:
	gravity_scale = 0

func enable_gravity() -> void:
	gravity_scale = 1
