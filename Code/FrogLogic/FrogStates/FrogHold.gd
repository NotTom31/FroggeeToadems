extends State
class_name FrogHold

@export var frog : CharacterBody2D

func Enter():
	$"../../AnimatedSprite2D".play("idle")
	frog.disable_gravity()
	print("Held")

func Exit():
	frog.enable_gravity()
	print("Drop")

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	pass
