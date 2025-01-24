#Brian Cabrera - 9/18/2024 - 1:10 AM
extends CanvasLayer
class_name CanvasShop

var animation : AnimationPlayer
signal menu_closed()
signal menu_opened()

var opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	animation = get_node("Animation_Panel")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# set up buttons
	
	get_node("Menu/Back_Button").pressed.connect(_on_menu_closed)
	get_node("Open_Button").pressed.connect(_on_menu_opened)

func _on_menu_closed():
	animation.play("Transition_Out")
	$Open_Button.visible = true
	if get_tree().root.get_child(0) is Main:
		if get_tree().root.get_child(0).get_node("LevelManager") is LevelManager:
			get_tree().root.get_child(0).get_node("LevelManager").check_frog_total()
		else : get_tree().root.get_child(0).sound_manager.change_music_layer(0)

func _on_menu_opened():
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	animation.play("Transition_In")
	$Open_Button.visible = false
	get_tree().paused = true

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
		if get_tree().root.get_child(0) is Main:
			get_tree().root.get_child(0).play_shop_music(false)
