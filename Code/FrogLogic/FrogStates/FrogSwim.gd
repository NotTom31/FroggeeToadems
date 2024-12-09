extends State
class_name FrogSwim

@export var move_speed_x := 200
@export var move_speed_y :=60
# percentage of velocity maintained per delta step, 1 = no friction
@export var damping = 0.988

var move_direction : Vector2
var wander_time : float

#var to track if the frog has kicked (max acceleration)
var push : bool

#defining bounding box for frogs; closer they are to borders the more they are impelled to swim in; if beyond borders they can only swim in
var left_bound = -680
var right_bound = 800
var xrange = right_bound-left_bound
var hi_bound = 630
var lo_bound = 750
var yrange = lo_bound-hi_bound


func randomize_wander():
	# calculate how close frogs are to center of bounding box
	# if at center return 0
	# if at edges, return 1 (right) or -1 (left)
	# outside of edges, |ratio| > 1
	var ratiox = (2*(frog.position.x-left_bound)/xrange) - 1
	var ratioy = (2*(frog.position.y-hi_bound)/yrange)- 1
	# ratio is used in denominator, so must handle divide by 0 case w arbitrary small number
	if ratiox == 0:
		ratiox = .01
	if ratioy == 0:
		ratioy = .01

	move_direction = Vector2(
		# x dir
		randf_range(-1, 1)
		# random component more influential if close to center
		*(1/ratiox)
		# bias more influential if close to edge
		-ratiox,
		# y dir
		randf_range(-1,1)*(1/ratioy)-ratioy
		# convert to unit vec
		).normalized()
	wander_time = randf_range(1, 4)
	# reset velocity, which is gradually decreased in delta function
	push = true

	# old implementation, rejected bc all frogs tend to center
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
	frog.disable_gravity()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("splash_med")
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
		#Transitioned.emit(self, "FrogCharge")
		# changed from forcing jump after each wander to chance of jump after each wander
		var jump_chance = randi_range(1,3)
		if jump_chance == 3:
			Transitioned.emit(self, "FrogCharge")
		else:
			randomize_wander()

func Physics_Update(delta: float):
	if push == true: #frog: #&& frog.is_on_floor():
		frog.velocity = Vector2(move_direction.x * move_speed_x, move_direction.y * move_speed_y)
		push = false
	else:
		frog.velocity = frog.velocity*damping
