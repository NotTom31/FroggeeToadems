extends Node2D

var parent_rigid_body: RigidBody2D = null

func _ready() -> void:
	parent_rigid_body = get_parent() as RigidBody2D
	
	if parent_rigid_body != null:
		print("Controlling parent: ", parent_rigid_body.name)
	else:
		print("Frog parent is not a RigidBody2D!")
