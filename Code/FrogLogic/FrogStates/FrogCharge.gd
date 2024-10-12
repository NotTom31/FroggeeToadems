extends State
class_name FrogCharge

@export var min_charge_time := 1.0
@export var max_charge_time := 3.0

var CanJump

func Enter():
	CanJump = true
	play_charge_animation()

func Exit():
	CanJump = false

func play_charge_animation():
	$"../../FrogSpriteHandler".play_charge()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("bounce_charge")
	var charge_time = randf_range(min_charge_time, max_charge_time)
	await get_tree().create_timer(charge_time).timeout
	if CanJump:
		Transitioned.emit(self, "FrogJump")
