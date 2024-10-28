extends State
class_name FrogCharge

#copy of variables for old bounce charge implementation
#@export var min_charge_time := 1.0
#@export var max_charge_time := 3.0

@export var slow_charge := 5.0
@export var medium_charge := 3.65
@export var fast_charge := 2.3

var CanJump

func Enter():
	CanJump = true
	play_charge_animation()

func Exit():
	CanJump = false


func play_charge_animation():
	$"../../FrogSpriteHandler".play_charge()
	var jump_time = randi_range(0,2) # 0 slow, 1 medium, 2 fast
	match jump_time:
		0:
			var charge_time = slow_charge
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("wert_slow")
				get_tree().root.get_child(0).play_sound("bounce_charge_slow")
			await get_tree().create_timer(charge_time).timeout
		1:
			var charge_time = medium_charge
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("wert_medium")
				get_tree().root.get_child(0).play_sound("bounce_charge_medium")
			await get_tree().create_timer(charge_time).timeout
		2:
			var charge_time = fast_charge
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("wert_fast")
				get_tree().root.get_child(0).play_sound("bounce_charge_fast")
			await get_tree().create_timer(charge_time).timeout

	
	if CanJump:
		Transitioned.emit(self, "FrogJump")

# copy of old implementation
#func play_charge_animation():
	#$"../../FrogSpriteHandler".play_charge()
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).play_sound("wert")
		#get_tree().root.get_child(0).play_sound("bounce_charge")
	#var charge_time = randf_range(min_charge_time, max_charge_time)
	#await get_tree().create_timer(charge_time).timeout
	#if CanJump:
		#Transitioned.emit(self, "FrogJump")
