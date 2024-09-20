extends Area2D
class_name FrogDetectionArea

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if area.get_parent() is BasicFrog:
		parent.transition_to_swim()
