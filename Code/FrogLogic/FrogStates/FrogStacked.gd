extends State
class_name FrogStacked

var blink_timer : float = 0.0

func Enter():
	$"../../AnimatedSprite2D".play("idle")
	frog.disable_gravity()
	set_random_blink_timer()

func Exit():
	pass

func set_random_blink_timer():
	blink_timer = randf_range(3, 8)

func Update(delta: float):
	blink_timer -= delta
	if blink_timer <= 0:
		$"../../AnimatedSprite2D".play("blink")
		set_random_blink_timer()

func Physics_Update(delta: float):
	pass