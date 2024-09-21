class_name BasicFrog
extends CharacterBody2D

@export var gravity := 980.0

var StateMachine
var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 900  # Cap how fast we can throw the frogs
var max_rotation_angle = deg_to_rad(40) 
var rotation_speed = 3  # How fast the rotation should change
var mouse_position
var is_sprite_flipped = false

var original_layer: int
var original_mask: int

var slot_beneath : FrogSlot = null
signal Transitioned

var on_lillypad := false:
	set(value):
		on_lillypad = value
		$SlotOnHead.on_lillypad = value
		$SlotOnHead.active = value

signal frog_deselected(frog : BasicFrog, pos : Vector2)

func _ready() -> void:
	StateMachine = get_node("StateMachine")
	original_layer = collision_layer

func _process(delta: float) -> void:
	if selected:
		follow_mouse(delta, $FrogBase.position)

func follow_mouse(delta: float, offset: Vector2) -> void:
	# Calculate the velocity of the mouse
	offset -= $FrogBase.position
	mouse_position = get_global_mouse_position()
	mouse_velocity = (mouse_position - global_position) / delta  # Calculate velocity
	global_position = mouse_position + offset
	apply_rotation_based_on_velocity(delta)
	var frog_on_head : BasicFrog = $SlotOnHead.inhabitant
	if frog_on_head != null:
		frog_on_head.follow_mouse(delta, offset + $SlotOnHead.position)

func apply_rotation_based_on_velocity(delta: float) -> void:
	var horizontal_speed = mouse_velocity.x
	
	var target_rotation_angle = clamp(horizontal_speed / max_velocity * max_rotation_angle, -max_rotation_angle, max_rotation_angle)
	
	#interpolate current rotation to target rotation
	$AnimatedSprite2D.rotation = lerp($AnimatedSprite2D.rotation, target_rotation_angle, rotation_speed * delta)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not selected:
			selected = true
			Transitioned.emit("FrogHold")
			collision_layer = 0
			velocity = Vector2.ZERO
			assign_to_slot(null)
		else:
			selected = false
			frog_deselected.emit(self, position)
	#else:
	#		selected = false
	#		collision_layer = original_layer
	#		mouse_velocity = mouse_velocity.limit_length(max_velocity)
	#		velocity = mouse_velocity


func assign_to_slot(new_slot: FrogSlot) -> void:
	if (slot_beneath != null):
		slot_beneath.inhabitant = null
	slot_beneath = new_slot
	if (slot_beneath != null):
		slot_beneath.inhabitant = self
		on_lillypad = slot_beneath.on_lillypad
	else:
		on_lillypad = false

func snap_to_slot(slot: FrogSlot) -> void:
	position = slot.global_position - $FrogBase.position
	$AnimatedSprite2D.rotation = 0
	var frog_on_top : BasicFrog = $SlotOnHead.inhabitant
	disable_gravity()
	if (frog_on_top != null):
		frog_on_top.snap_to_slot($SlotOnHead)

func disable_gravity() -> void:
	gravity = 0

func enable_gravity() -> void:
	gravity = 980.0

func transition_to_swim():
	Transitioned.emit("FrogSwim")

func _physics_process(delta: float):
	# Apply gravity to velocity
	velocity.y += gravity * delta
	# Move the character with the applied gravity
	move_and_slide()
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		is_sprite_flipped = true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		is_sprite_flipped = false

func _on_mouse_exited() -> void:
	selected = false #failsafe

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.
