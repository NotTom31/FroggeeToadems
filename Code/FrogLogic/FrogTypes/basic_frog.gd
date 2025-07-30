class_name BasicFrog
extends CharacterBody2D

@export var gravity := 980.0
@export var type : MagicManager.FrogType
# spawn speed used by frog spawner, different for each frog
@export var spawn_speed = .75

var lvl_manager : LevelManager
var StateMachine
var selected = false
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 900  # Cap how fast we can throw the frogs
var max_rotation_angle = deg_to_rad(40) 
var rotation_speed = 3  # How fast the rotation should change
var mouse_position
var is_sprite_flipped = false
var ribbit_timer : float = 0.0
var over_water = false
var over_rock = false
var behind_boat = false

# particle variables
@export var particle_amt = 15
@export var particle_zone_r = 50
@export var particle_ratio = 0
@export var particle_lifetime = 1
@export var particle_damping = 10.0
# note: speed cannot be modified w/ code, can be changed in process material>spawn>>velocity>initial velocity
# speed uses standard value 100 +- 45
var particles_on = false

var original_layer: int
var original_mask: int

var slot_beneath : FrogSlot = null
signal Transitioned
signal frog_deselected(frog : BasicFrog, pos : Vector2, over_water : bool)
signal slot_assigned(frog : BasicFrog, slot : FrogSlot)

var on_lillypad := false:
	set(value):
		on_lillypad = value
		$SlotOnHead.on_lillypad = value
		$SlotOnHead.active = value

func _ready() -> void:
	StateMachine = get_node("StateMachine")
	original_layer = collision_layer
	particle_cease()
	set_random_ribbit_timer()
	#@export var particle_amt = 15

	$GPUParticles2D.process_material.set_emission_sphere_radius(particle_zone_r)# = particle_zone_r
	$GPUParticles2D.amount_ratio = particle_ratio
	$GPUParticles2D.amount = particle_amt
	$GPUParticles2D.lifetime = particle_lifetime


func _process(delta: float) -> void:
	ribbit_timer -= delta
	if selected:
		follow_mouse(delta, $FrogBase.position)
	if ribbit_timer <= 0:
		if get_tree().root.get_child(0) is Main:
			match type:
				3, 4: #fat, mud
					get_tree().root.get_child(0).play_sound("big_ribbit")
				0: #basic, 
					get_tree().root.get_child(0).play_sound("default_ribbit")
				1: # tropical
					get_tree().root.get_child(0).play_sound("tropical_ribbit")
				2: #small
					get_tree().root.get_child(0).play_sound("tiny_ribbit")
		$FrogSpriteHandler.play_ribbit()
		set_random_ribbit_timer()
	if particles_on == true:
		particle_ratio = particle_ratio + (1.0-particle_ratio)/particle_damping
		$GPUParticles2D.amount_ratio = particle_ratio

			


func follow_mouse(delta: float, offset: Vector2) -> void:
	# Calculate the velocity of the mouse
	offset -= $FrogBase.position
	mouse_position = get_global_mouse_position()
	mouse_velocity = (mouse_position - global_position + offset) / delta  # Calculate velocity
	global_position = mouse_position + offset
	apply_rotation_based_on_velocity(delta)
	var frog_on_head = get_frog_on_head()
	if frog_on_head != null:
		frog_on_head.follow_mouse(delta, offset + $SlotOnHead.position)

func get_frog_on_head() -> BasicFrog:
	return $SlotOnHead.inhabitant

func apply_rotation_based_on_velocity(delta: float) -> void:
	var horizontal_speed = mouse_velocity.x
	
	var target_rotation_angle = clamp(horizontal_speed / max_velocity * max_rotation_angle, -max_rotation_angle, max_rotation_angle)
	
	#interpolate current rotation to target rotation
	$AnimatedSprite2D.rotation = lerp($AnimatedSprite2D.rotation, target_rotation_angle, rotation_speed * delta)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#extra check bc sometimes lvl_manager.state returns nil, causing error
		if lvl_manager:
			if lvl_manager.state == LevelManager.ClickState.DEFAULT:
				if not selected:
					selected = true
					Transitioned.emit("FrogHold")
					collision_layer = 0
					velocity = Vector2.ZERO
					assign_to_slot(null)
				else:
					selected = false
					frog_deselected.emit(self, global_position, over_water)
	elif event is InputEventMouse:
		#extra check bc sometimes lvl_manager.state returns nil, causing error
		if lvl_manager:
			if lvl_manager.state == LevelManager.ClickState.WAND:
				var lil = find_lillypad_below()
				if lil != null:
					lil.check_for_magic()
					lil.fountain()
			
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
	slot_assigned.emit(self, slot_beneath)

func snap_to_slot(slot: FrogSlot) -> void:
	global_position = slot.global_position - $FrogBase.position
	$AnimatedSprite2D.rotation = 0
	var frog_on_top : BasicFrog = $SlotOnHead.inhabitant
	disable_gravity()
	if (frog_on_top != null):
		frog_on_top.snap_to_slot($SlotOnHead)

func visible() -> void:
	$AnimatedSprite2D.visible = true

func invisible() -> void:
	$AnimatedSprite2D.visible = false

func disable_gravity() -> void:
	gravity = 0

func enable_gravity() -> void:
	gravity = 980.0

func transition_to_swim():
	Transitioned.emit("FrogSwim")
	$AnimatedSprite2D.rotation = 0
	
func transition_to_jump():
	Transitioned.emit("FrogJump")

func transition_to_fall():
	Transitioned.emit("FrogFall")

func particle_emit() -> void:
	$GPUParticles2D.emitting = true
	particles_on = true

func particle_cease() -> void:
	$GPUParticles2D.emitting = false
	particles_on = false

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
	pass
# removes this frog's head slot from the list of slots and deletes the frog
func remove() -> void:
	print("goodbye!")
	lvl_manager.remove_frog_slot($SlotOnHead)
	lvl_manager.check_for_game_over()
	queue_free()

func get_held_frog_types() -> Array[MagicManager.FrogType]:
	var types_above : Array[MagicManager.FrogType] = []
	if $SlotOnHead.inhabitant != null:
		types_above = $SlotOnHead.inhabitant.get_held_frog_types()
	types_above.append(type)
	return types_above
	
func get_head_slot() -> FrogSlot:
	return $SlotOnHead
	
func find_lillypad_below() -> Lillypad:
	if slot_beneath == null:
		return null
	var holder_beneath = slot_beneath.get_parent()
	if holder_beneath is BasicFrog:
		return holder_beneath.find_lillypad_below()
	elif holder_beneath is Lillypad:
		return holder_beneath
	return null
	
# causes this frog and all frogs standing on it to explode into a frog fountain
func fountain() -> void:
	var frog_on_head : BasicFrog = get_frog_on_head()
	if frog_on_head != null:
		frog_on_head.fountain()
	$AnimatedSprite2D.rotation = 0
	transition_to_jump()

func tumble() -> void:
	var frog_on_head : BasicFrog = get_frog_on_head()
	if frog_on_head != null:
		frog_on_head.tumble()
	#$AnimatedSprite2D.rotation = 0
	transition_to_fall()

func set_random_ribbit_timer():
	ribbit_timer = randf_range(3, 8)
