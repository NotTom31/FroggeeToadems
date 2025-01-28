extends State
class_name FrogHold

func Enter():
	$"../../FrogSpriteHandler".play_idle()
	$"../../Watermask".water_unmask()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("frog_click")
	frog.disable_gravity()

func Exit():
	pass
	
func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
