extends State
class_name FrogHold

func Enter():
	$"../../FrogSpriteHandler".play_idle()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("frog_click")
	frog.disable_gravity()

func Exit():
	frog.enable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
