extends State
class_name FrogStacked

@export var blink_time_min = 3
@export var blink_time_max = 8
var blink_timer : float = 0.0

func Enter():
	$"../../FrogSpriteHandler".play_idle()
	frog.disable_gravity()
	set_random_blink_timer()

func Exit():
	var fs : FrogSlot = $"../..".slot_beneath
	if fs != null:
		fs.inhabitant = null
	$"../..".slot_beneath = null

func set_random_blink_timer():
	blink_timer = randf_range(3, 8)

func Update(delta: float):
	blink_timer -= delta
	if blink_timer <= 0:
		$"../../FrogSpriteHandler".play_blink()
		set_random_blink_timer()

func Physics_Update(delta: float):
	pass
