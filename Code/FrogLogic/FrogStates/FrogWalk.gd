extends State
class_name FrogWalk

@export var frog : CharacterBody2D
@export var move_speed := 40.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3)

func Enter():
	$"../../AnimatedSprite2D".play("idle")
	randomize_wander()

func Exit():
	pass

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		Transitioned.emit(self, "FrogJump") # test
		#randomize_wander()

func Physics_Update(delta: float):
	if frog && frog.is_on_floor():
		frog.velocity = Vector2(move_direction.x * move_speed, frog.velocity.y + move_direction.y)
		frog.rotation = lerp(frog.rotation, 0.0, 1.0)