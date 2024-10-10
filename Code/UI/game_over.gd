extends CanvasLayer

@export var level_manager : LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	level_manager.get_parent().open_menu()


func _on_restart_button_pressed() -> void:
	print(level_manager.get_parent())
	level_manager.get_parent().restart_level()
	self.visible = false
