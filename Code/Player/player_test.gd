extends CharacterBody2D

const max_speed = 400
const accel = 1500
const friction = 600

var input = Vector2.ZERO

func get_input():
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input.normalized()

func player_movement(input, delta):
	if input: velocity = velocity.move_toward(input * max_speed , delta * accel)
	else: velocity = velocity.move_toward(Vector2(0,0), delta * friction)

func _physics_process(delta):
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	player_movement(input, delta)
	move_and_slide()
