extends State
class_name FrogStacked

@export var blink_time_min = 3
@export var blink_time_max = 8
@export var charge_time_min = 8
@export var charge_time_max = 12
var blink_timer : float = 0.0
var charge_timer : float = 0.0
var CanCharge := true

func Enter():
	$"../../FrogSpriteHandler".play_idle()
	frog.disable_gravity()
	frog.velocity = Vector2(0,0)
	frog.rotation = 0
	set_random_blink_timer()
	set_random_charge_timer()

func Exit():
	var fs : FrogSlot = $"../..".slot_beneath
	if fs != null:
		fs.inhabitant = null
	$"../..".slot_beneath = null

func set_random_blink_timer():
	blink_timer = randf_range(blink_time_min, blink_time_max)
	
func set_random_charge_timer():
	charge_timer = randf_range(charge_time_min, charge_time_max)

func Update(delta: float):
	blink_timer -= delta
	if blink_timer <= 0:
		$"../../FrogSpriteHandler".play_blink()
		set_random_blink_timer()
	
	if CanCharge:
		charge_timer -= delta
		if charge_timer <= 0 and CanCharge:
			var frog_on_head : BasicFrog = frog.get_frog_on_head()
			set_random_charge_timer()
			if frog_on_head == null and frog.on_lillypad:
				Transitioned.emit(self, "FrogCharge", true) #Skips FrogStacked Exit function
			

func Physics_Update(delta: float):
	pass
