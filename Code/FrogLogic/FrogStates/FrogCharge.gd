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
	var charge_time = randf_range(min_charge_time, max_charge_time)
	await get_tree().create_timer(0.2).timeout
	if CanJump:
		Transitioned.emit(self, "FrogJump")
