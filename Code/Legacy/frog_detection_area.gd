extends Area2D
class_name FrogDetectionArea

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	parent.over_water = true
	var current_state = parent.get_node("StateMachine").current_state
	if current_state is FrogFall or current_state is FrogJump:
		parent.transition_to_swim()

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	parent.over_water = false
