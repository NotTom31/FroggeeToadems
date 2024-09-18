#Brian Cabrera - 9/18/2024 - 1:10 AM
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	get_node("Animation_Panel").connect("animation_finished", Callable(self, "_on_animation_finished"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass  # No need to use 'delta', prefix it with '_delta'.

# Function triggered when the "close" button is pressed
func _on_button_close_pressed() -> void:
	# Plays the "Transition_Out" animation when the close button is pressed
	get_node("Animation_Panel").play("Transition_Out")

# This function is called when the animation finishes
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
