#Brian Cabrera - 9/18/2024 - 1:10 AM
extends CanvasLayer

var animation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	animation = get_node("Animation_Panel")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animation.play("Start")

func _on_back_button_pressed() -> void:
	animation.play("Transition_Out")
	$Open_Button.visible = true

func _on_open_button_pressed() -> void:
	animation.play("Transition_In")
	$Open_Button.visible = false
	get_tree().paused = true

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
