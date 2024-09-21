class_name Lillypad
extends Area2D

@export var lvl_manager : LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_held_frog_types() -> Array[MagicManager.FrogType]:
	if $FrogSlot.inhabitant == null:
		return []
	else:
		return $FrogSlot.inhabitant.get_held_frog_types()

func fountain() -> void:
	if $FrogSlot.inhabitant != null:
		$FrogSlot.inhabitant.fountain()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if lvl_manager.state == LevelManager.ClickState.WAND:
			check_for_magic()
		fountain()

func check_for_magic() -> void:
	print("check for magic")
	lvl_manager.set_state(LevelManager.ClickState.DEFAULT)
