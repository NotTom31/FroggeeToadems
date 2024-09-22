extends State
class_name FrogFall

func Enter():
	$"../../FrogSpriteHandler".play_jump()
	var frog_on_head = frog.get_frog_on_head()
	if (frog_on_head != null):
		frog_on_head.tumble()
	frog.enable_gravity()
	frog.assign_to_slot(null)
	frog.velocity = frog.mouse_velocity.limit_length(frog.max_velocity)  # Apply mouse velocity to the RigidBody2D
	frog.velocity += Vector2(randf_range(-50, 50), randf_range(-50, 50)) # Apply slight variation to velocity

func Exit():
	frog.disable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
