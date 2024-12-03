extends State
class_name FrogSwim

@export var move_speed_x := 200 # originally 40.0, trying this for push mechanic
@export var move_speed_y := 60
var move_direction : Vector2
var wander_time : float
var push = true

# brendan's note: change to "kick" that gives some acceleration in a random direction

var left_bound = -680
var right_bound = 800
var xrange = right_bound-left_bound
var hi_bound = 630
var lo_bound = 750
var yrange = lo_bound-hi_bound

func randomize_wander():
	
	var ratiox = (2*(frog.position.x-left_bound)/xrange) - 1
	var ratioy = (2*(frog.position.y-hi_bound)/yrange)- 1
	if ratiox == 0:
		ratiox = .01
	if ratioy == 0:
		ratioy = 0.01
	
	move_direction = Vector2(
		# x dir
		randf_range(-1, 1)*(1/ratiox)-ratiox,
		# y dir
		randf_range(-1,1)*(1/ratioy)-ratioy
		).normalized()
	wander_time = randf_range(1, 4)
	push = true
	
	#var ratiox = (frog.position.x-left_bound)/xrange
	#var ratioy = (frog.position.y-hi_bound)/yrange
	#
	#move_direction = Vector2(
		## x dir
		#randf_range(-1*ratiox, 1-ratiox),
		## y dir
		#randf_range(-1*(ratioy), 1-(ratioy))
		#).normalized()
	#wander_time = randf_range(1, 4)

func Enter():
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("splash_med")
	frog.disable_gravity()
	$"../../FrogSpriteHandler".play_jump()
	#if frog.is_sprite_flipped:
	#	frog.rotation_degrees = 240
	#else:
	#	frog.rotation_degrees = 60
	randomize_wander()

func Exit():
	frog.rotation_degrees = 0
	pass

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		pass
		var jump_chance = randi_range(1,3)
		if jump_chance == 3:
			Transitioned.emit(self, "FrogCharge")
		randomize_wander()

func Physics_Update(delta: float):
	if push == true: #frog: #&& frog.is_on_floor():
		frog.velocity = Vector2(move_direction.x * move_speed_x, move_direction.y * move_speed_y)#frog.velocity.y + move_direction.y)
		#frog.rotation = lerp(frog.rotation, 60.0, 1.0)
		push = false
	else:
		frog.velocity = frog.velocity*0.988
		
