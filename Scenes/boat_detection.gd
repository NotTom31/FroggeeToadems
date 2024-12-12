extends Area2D
class_name BoatDetectionArea

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	# allow random amount of time to pass so border is less obvious
	await get_tree().create_timer(randf_range(0,1)).timeout
	if is_instance_valid(parent): 
		parent.behind_boat = true

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is not BasicFrog:
		return
	parent.behind_boat = false
