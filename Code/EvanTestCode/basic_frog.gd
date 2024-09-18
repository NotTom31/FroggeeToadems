class_name BasicFrog extends Area2D

var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 900  # Cap how fast we can throw the frogs
var max_rotation_angle = deg_to_rad(40) 
var rotation_speed = 3  # How fast the rotation should change

var original_mask: int

var slot_beneath : FrogSlot = null

var on_lillypad := false:
	set(value):
		on_lillypad = value
		$SlotOnHead.on_lillypad = value
		$SlotOnHead.active = value

signal frog_deselected(frog : BasicFrog, pos : Vector2)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if selected:
		follow_mouse(delta)

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
	$Sprite2D.rotation = lerp($Sprite2D.rotation, target_rotation_angle, rotation_speed * delta)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not selected:
			selected = true
			assign_to_slot(null)
		else:
			selected = false
			frog_deselected.emit(self, position)
	
func assign_to_slot(new_slot: FrogSlot) -> void:
	if (slot_beneath != null):
		slot_beneath.inhabitant = null
	slot_beneath = new_slot
	if (slot_beneath != null):
		slot_beneath.inhabitant = self
		print(slot_beneath.on_lillypad)
		on_lillypad = slot_beneath.on_lillypad
	else:
		on_lillypad = false
		
	
func snap_to_slot(slot: FrogSlot) -> void:
	position = slot.global_position - $FrogBase.position
	$Sprite2D.rotation = 0
