extends State
class_name FrogFall

func Enter():
	$"../../AnimatedSprite2D".play("jump")
	frog.enable_gravity()

func Exit():
	frog.disable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
