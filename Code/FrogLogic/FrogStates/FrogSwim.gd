extends State
class_name FrogSwim

@export var move_speed_x := 200
@export var move_speed_y :=60
# percentage of velocity maintained per delta step, 1 = no friction
@export var damping = 0.988

var move_direction : Vector2
var wander_time : float

# var to track if the frog has kicked (max acceleration)
var push : bool
# var to track when transitioning from border ai to normal swim. thought this might fix rapid switching behavior; didn't
var boundary_ai = false

# define bounding box for frogs; closer they are to borders the more they are impelled to swim in; if beyond borders they can only swim in
var left_bound = -680
var right_bound = 800
var xrange = right_bound-left_bound
var hi_bound = 630
var lo_bound = 750
var yrange = lo_bound-hi_bound

func Enter():
	frog.disable_gravity()
	$"../../FrogSpriteHandler".rotation = 0
	$"../../FrogSpriteHandler".play_jump()
	var frog_on_head = frog.get_frog_on_head()
	if (frog_on_head != null):
		frog_on_head.tumble()
	frog.assign_to_slot(null)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("splash_med")
	randomize_wander()

#choose direction for frog to swim and length of time until next wander/push occurs
func randomize_wander():
	# calculate how close frogs are to center of bounding box
	# if at center return 0
	# if at edges, return 1 (@right bound) or -1 (@left bound)
	# outside of edges, |ratio| > 1
	var ratiox = (2*(frog.position.x-left_bound)/xrange) - 1
	var ratioy = (2*(frog.position.y-hi_bound)/yrange)- 1
	
	# ratio is used in denominator, so must handle divide by 0 case w arbitrary small number
	if ratiox == 0:
		ratiox = .01
	if ratioy == 0:
		ratioy = .01
	
	# create random unit vector move_direction that is more likely to point to center the closer it is to boundary, must point at center beyond boundary
	# note: positive x velocity means towards right side
	# note2: squaring ratio (and adding back in positive/negative value in bias portion) or cubing it (to maintain positive/neg) 
	# may improve border between random behavior and biased inwards behavior; not doing now to save computation
	move_direction = Vector2(
		# x dir
		# formula breakdown:
		# random component more influential the lower ratio is (closer to center)
		randf_range(-1, 1)*(1/ratiox)
		# bias more influential the higher ratio is (close to / beyond edge)
		-ratiox,
		
		# y dir
		# same formula as x
		randf_range(-1,1)*(1/ratioy)-ratioy
		# convert to unit vec
		).normalized()
	
	# set time until next push
	wander_time = randf_range(1, 4)
	# let delta function know to reset velocity, which will gradually decrease after initial push
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

func Exit():
	frog.rotation = 0
	pass

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		# by default 1/3 chance of jumping after each wander
		var jump_chance = randi_range(1,3)
		if jump_chance == 3:
			Transitioned.emit(self, "FrogCharge")
		else:
			randomize_wander()

var swim_cooldown = 0.5  # Time to wait before swimming again
var swim_timer = 0.0    # Tracks the remaining cooldown time

func Physics_Update(delta: float):
	# Update the cooldown timer
	if swim_timer > 0:
		swim_timer -= delta
	
	# push = false # for testing, see note on final else in function
	if push == false:
		# activate boundary ai if intersecting w rock or boat detection areas 
		# if frog is at boundary, it can do anything from stay still to swim inwards but can no longer swim out of bounds
		# however, if frog is intersecting with a visual obstacle, this portion of code should guarantee they swim inwards with max velocity
		if swim_timer <= 0:  # Only allow boundary behavior if cooldown has expired
			if frog.over_rock == true:
				move_direction.x = -1
				frog.velocity = Vector2(move_direction.x * move_speed_x, move_direction.y * move_speed_y)
				boundary_ai = true
				swim_timer = swim_cooldown  # Reset cooldown
			elif frog.behind_boat == true:
				move_direction.x = 1
				frog.velocity = Vector2(move_direction.x * move_speed_x, move_direction.y * move_speed_y)
				boundary_ai = true
				swim_timer = swim_cooldown  # Reset cooldown
			# damping behavior
			else:
				frog.velocity = frog.velocity * damping
				# initiate push if leaving boundary
				if boundary_ai == true:
					boundary_ai = false
					push = true
	else:
		frog.velocity = Vector2(move_direction.x * move_speed_x, move_direction.y * move_speed_y)
		push = false
