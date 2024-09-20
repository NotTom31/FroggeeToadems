extends State
class_name FrogJump

@export var jump_speed := 40.0
@export var jump_height := 500.0
@export var jump_animation: String = "jump"
@export var rotation_target := 90.0
@export var rotation_speed := 3.0  # Speed of rotation lerp

var original_rotation = 0.0
var jump_direction: Vector2
var has_jumped: bool = false

func randomize_jump_direction():
	var direction = randf_range(-1, 1)
	jump_direction = Vector2(direction, -1).normalized()

func Enter():
	randomize_jump_direction()
	jump()

func Exit():
	pass

func jump():
	if frog:
		$"../../AnimatedSprite2D".play("jump")
		frog.velocity = jump_direction * jump_speed
		frog.velocity.y = -jump_height
		has_jumped = true
		frog.rotation_degrees = rotation_target
		#print("Jumping with direction: ", jump_direction)
	else:
		print("Error: frog is not assigned or invalid.")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	if has_jumped and frog.is_on_floor():
		has_jumped = false
		Transitioned.emit(self, "FrogWalk")

func _process(delta: float):
	if has_jumped and is_instance_valid(frog):
		# Lerp rotation back to 0 degrees
		frog.rotation_degrees = lerp(frog.rotation_degrees, original_rotation, rotation_speed * delta)
