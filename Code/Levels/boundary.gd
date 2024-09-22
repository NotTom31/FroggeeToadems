extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	var current_state = parent.get_node("StateMachine").current_state
	if current_state is FrogHold or current_state is FrogStacked:
		return
	parent.remove()
