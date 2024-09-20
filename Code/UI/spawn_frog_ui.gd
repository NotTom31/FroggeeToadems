extends Control

@export var Frog : PackedScene

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	# Instantiate the frog scene
	var FrogInst = Frog.instantiate()

	# Add it as a child to the root scene instead of this UI element
	get_tree().root.add_child(FrogInst)
	
	# Set the position of the frog to the mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	FrogInst.position = mouse_pos
	FrogInst.selected = true
