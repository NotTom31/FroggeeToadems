extends Control

var Frog= preload("res://Scenes/Objects/frog.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var FrogInst = Frog.instantiate()
	add_child(FrogInst)
	FrogInst.position = Vector2(randi_range(10,100), randi_range(10,100))
