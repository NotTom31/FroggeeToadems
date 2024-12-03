extends State
class_name FrogCharge

#copy of variables for old bounce charge implementation
@export var min_charge_time := 1.0
@export var max_charge_time := 3.0


var CanJump

func Enter():
	CanJump = true
	frog.velocity = frog.velocity/5
	play_charge_animation()

func Exit():
	CanJump = false

# copy of old implementation
func play_charge_animation():
	$"../../FrogSpriteHandler".play_charge()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("wert")
		get_tree().root.get_child(0).play_sound("bounce_charge_medium")
	var charge_time = randf_range(min_charge_time, max_charge_time)
	await get_tree().create_timer(charge_time).timeout
	if CanJump:
		Transitioned.emit(self, "FrogJump")
