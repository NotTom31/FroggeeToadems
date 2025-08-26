extends Node2D
class_name MenuManager

#brendan here. might end up not using this since there aren't too many menus. worried there will be too many process functions in which case this will be usefuol


@onready var openmenu : String = ""
signal closemenu()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func current_menu(new_menu):
	openmenu = new_menu
	print("New menu is " + openmenu)

func open_credits():
	current_menu("credits")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if openmenu != "":
		if Input.is_action_just_pressed("escape"):
			get_tree().call_group("UI Canvases", ("close_" + openmenu))
			print("escaping " + openmenu + " menu")
			current_menu("")
			
