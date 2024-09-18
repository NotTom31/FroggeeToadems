class_name LevelManager extends Node2D

@export var frog_slots : Array[FrogSlot] = []

func _ready() -> void:
	pass
	
func add_frog_slot(slot : FrogSlot) -> void:
	frog_slots.append(slot)
	
func remove_frog_slot(slot : FrogSlot) -> void:
	frog_slots.erase(slot)

func closest_open_frog_slot(pos : Vector2) -> FrogSlot:
	var distance = 1000
	var result : FrogSlot = null
	for fs in frog_slots:
		if (not fs.is_open()):
			continue
		var temp_dist = pos.distance_to(fs.global_position)
		if (temp_dist < distance):
			distance = temp_dist
			result = fs
	return result

func _on_frog_deselected(frog: BasicFrog, pos: Vector2) -> void:
	var slot = closest_open_frog_slot(pos)
	frog.assign_to_slot(slot)
	frog.snap_to_slot(slot)
