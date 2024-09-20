extends State
class_name FrogFall

var mouse_velocity = Vector2()

func Enter():
	$"../../AnimatedSprite2D".play("jump")
	frog.enable_gravity()
	var mouse_velocity = mouse_velocity.limit_length(frog.max_velocity)
	frog.velocity = mouse_velocity  # Apply mouse velocity to the RigidBody2D

func Exit():
	frog.disable_gravity()

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
