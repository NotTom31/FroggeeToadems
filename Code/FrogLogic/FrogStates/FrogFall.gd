extends State
class_name FrogFall

func Enter():
	$"../../FrogSpriteHandler".play_jump()
	frog.enable_gravity()
	frog.velocity = frog.mouse_velocity.limit_length(frog.max_velocity)  # Apply mouse velocity to the RigidBody2D

func Exit():
	frog.disable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
