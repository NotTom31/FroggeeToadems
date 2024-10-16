extends State
class_name FrogSwim

@export var move_speed := 40.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3)

func Enter():
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("splash_med")
	$"../../FrogSpriteHandler".play_jump()
	#if frog.is_sprite_flipped:
	#	frog.rotation_degrees = 240
	#else:
	#	frog.rotation_degrees = 60
	randomize_wander()

func Exit():
	frog.rotation_degrees = 0
	pass

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		pass
		Transitioned.emit(self, "FrogCharge")
		randomize_wander()

func Physics_Update(delta: float):
	if frog && frog.is_on_floor():
		frog.velocity = Vector2(move_direction.x * move_speed, frog.velocity.y + move_direction.y)
		#frog.rotation = lerp(frog.rotation, 60.0, 1.0)
