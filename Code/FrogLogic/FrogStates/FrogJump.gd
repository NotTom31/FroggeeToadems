extends State
class_name FrogJump

@export var min_horizontal_distance := 80.0
@export var max_horizontal_distance := 300.0
@export var min_jump_height := 600.0
@export var max_jump_height := 1500.0
@export var jump_animation: String = "jump"
var rotation_target := 90.0
@export var rotation_speed := 3.0  # Speed of rotation lerp

var original_rotation = 0.0
var jump_direction: Vector2
var has_jumped: bool = false
var direction

func randomize_jump_direction():
	direction = randf_range(-1, 1)
	jump_direction = Vector2(direction, -1)

func Enter():
	has_jumped = false
	jump()

func Exit():
	frog.rotation_degrees = 0

func jump():
	$"../../FrogSpriteHandler".play_charge()
	frog.enable_gravity()
	frog.assign_to_slot(null)
	randomize_jump_direction()
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).play_sound("boing1")
	if frog:
		if direction < 0:
			rotation_target = 90
		else:
			rotation_target = -90
		$"../../FrogSpriteHandler".play_jump()
		frog.velocity = jump_direction * randf_range(min_horizontal_distance, max_horizontal_distance)
		var jump_height = randf_range(min_jump_height, max_jump_height)
		frog.velocity.y = -jump_height
		has_jumped = true
		frog.rotation_degrees = rotation_target
		#print("Jumping with direction: ", jump_direction)
	else:
		print("Error: frog is not assigned or invalid.")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass

func _process(delta: float):
	if has_jumped and is_instance_valid(frog):
		# Lerp rotation back to 0 degrees
		frog.rotation_degrees = lerp(frog.rotation_degrees, original_rotation, rotation_speed * delta)
