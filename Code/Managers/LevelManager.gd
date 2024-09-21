class_name LevelManager extends Node2D

@export var frog_slots : Array[FrogSlot] = []
var state : ClickState = ClickState.DEFAULT
enum ClickState { DEFAULT, WAND }

func _ready() -> void:
	pass
	
func add_frog_slot(slot : FrogSlot) -> void:
	frog_slots.append(slot)
	
func remove_frog_slot(slot : FrogSlot) -> void:
	frog_slots.erase(slot)

func closest_open_frog_slot(pos : Vector2) -> FrogSlot:
	var distance = 150
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
	
	if slot == null:
		frog.Transitioned.emit("FrogFall")
		return
	
	frog.Transitioned.emit("FrogStacked")
	frog.assign_to_slot(slot)
	frog.snap_to_slot(slot)

func _on_frog_spawner_spawned_frog(frog: BasicFrog) -> void:
	add_frog_slot(frog.get_head_slot())
	frog.frog_deselected.connect(self._on_frog_deselected)
	frog.lvl_manager = self

func set_state(s: ClickState) -> void:
	state = s

func _on_wand_button_pressed() -> void:
	if state == ClickState.WAND:
		state = ClickState.DEFAULT
	else:
		state = ClickState.WAND
