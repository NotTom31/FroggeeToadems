extends CanvasLayer

@export var level_manager : LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	#get_tree().paused = false
	print(level_manager.get_parent())
	level_manager.get_parent().open_next_level()
	self.visible = false



func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	print("yop")
