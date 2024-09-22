extends CanvasLayer

var animation : AnimationPlayer

@export var magic : MagicManager
@export var text0 : Label
@export var text1 : Label
@export var text2 : Label
@export var text3 : Label
@export var text4 : Label
@export var text5 : Label
@export var text6 : Label
@export var text7 : Label

func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	animation = get_node("AnimationPlayer")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animation.play("Start")

func update_text() -> void:
	text0.text = magic.get_recipe_as_string(0)
	text1.text = magic.get_recipe_as_string(1)
	text2.text = magic.get_recipe_as_string(2)
	text3.text = magic.get_recipe_as_string(3)
	text4.text = magic.get_recipe_as_string(4)
	text5.text = magic.get_recipe_as_string(5)
	text6.text = magic.get_recipe_as_string(6)
	text7.text = magic.get_recipe_as_string(7)
	text7.text = magic.get_recipe_as_string(8)


func _on_open_button_pressed() -> void:
	update_text()
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).play_shop_music(true)
	animation.play("Transition_In")
	$OpenButton.visible = false
	#get_tree().paused = true


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
		#if get_tree().root.get_child(0) is Main:
			#get_tree().root.get_child(0).play_shop_music(false)


func _on_close_button_pressed() -> void:
	animation.play("Transition_Out")
	$OpenButton.visible = true
