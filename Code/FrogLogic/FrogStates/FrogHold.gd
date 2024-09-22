extends State
class_name FrogHold

func Enter():
	$"../../FrogSpriteHandler".play_idle()
	frog.disable_gravity()

func Exit():
	frog.enable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
