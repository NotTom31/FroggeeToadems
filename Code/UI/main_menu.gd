class_name MainMenu
extends Control


@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
#@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/SettingsButton as Button
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/CreditsButton as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
#@onready var settings_menu = preload("res://Scenes/UI/SettingsMenu.tscn") as PackedScene
@onready var credits_menu = preload("res://Scenes/UI/CreditsMenu.tscn") as PackedScene

@export var main : Main

func _ready():
	start_button.button_down.connect(on_start_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).open_gameplay(0)
		queue_free()
		main.shopkeep_visible(true)
	else:
		print("go to Main scene")

func on_credits_pressed() -> void:
	var scene_instance = credits_menu.instantiate()
	add_child(scene_instance)

func on_exit_pressed() -> void:
	get_tree().quit()
