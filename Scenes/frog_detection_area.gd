extends Area2D
class_name FrogDetectionArea

func _on_area_entered(area: Area2D) -> void:
	print(area.get_parent().name)
	var parent = area.get_parent()
	if area.get_parent() is BasicFrog:
		print("inif")
		parent.transition_to_swim()
