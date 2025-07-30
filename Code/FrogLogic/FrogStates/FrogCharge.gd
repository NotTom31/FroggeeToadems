extends State
class_name FrogCharge

#copy of variables for old bounce charge implementation
@export var min_charge_time := 1.0
@export var max_charge_time := 3.0
@export var pad_min_charge_time := 4.0
@export var pad_max_charge_time := 6.0

var CanJump

func Enter():
	CanJump = true
	frog.velocity = frog.velocity/5
	play_charge_animation()

func Exit():
	CanJump = false
	$JumpChargePlayer.stop()

# copy of old implementation
func play_charge_animation():
	$"../../FrogSpriteHandler".play_charge()
	var charge_time = randf_range(min_charge_time, max_charge_time)
	if frog.slot_beneath != null:
		charge_time = randf_range(pad_min_charge_time, pad_max_charge_time)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("wert")
		#higher pitch corresponding with lower charge time
		$JumpChargePlayer.pitch_scale = (4.3/(2.3+charge_time))*randf_range(0.95, 1.1)
		$JumpChargePlayer.volume_db = 15 + randf_range(-1.5,3)
		# play charge sound starting at point that is exactly 1 charge time before effect climaxes
		$JumpChargePlayer.play(4.9-charge_time)
		#get_tree().root.get_child(0).play_sound("bounce_charge_medium")
	await get_tree().create_timer(charge_time).timeout
	if CanJump and frog.get_frog_on_head() == null:
		Transitioned.emit(self, "FrogJump")
	elif frog.slot_beneath != null:
		$"../../FrogSpriteHandler".play_idle()
		Transitioned.emit(self, "FrogStacked")
