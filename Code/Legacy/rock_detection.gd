extends Area2D
class_name RockDetectionArea

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	# remove random time passing while troubleshooting swim behavior
	# allow random amount of time to pass so border is less obvious
	#await get_tree().create_timer(randf_range(0,.2)).timeout
	if is_instance_valid(parent): 
		parent.over_rock = true

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	parent.over_rock = false
