extends Node2D

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

#var parent_rigid_body: RigidBody2D = null

func _ready() -> void:
	#parent_rigid_body = get_parent() as RigidBody2D
	#if parent_rigid_body != null:
	#	print("Controlling parent: ", parent_rigid_body.name)
	#else:
	#	print("Frog parent is not a RigidBody2D!")
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
