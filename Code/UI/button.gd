extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("menu_click")




func _on_mouse_entered() -> void:
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("menu_hover")
