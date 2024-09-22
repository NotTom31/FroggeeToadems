class_name MainMenu
extends Control


@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/SettingsButton as Button
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/CreditsButton as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
#@onready var settings_menu = preload("res://Scenes/UI/SettingsMenu.tscn") as PackedScene
@onready var credits_menu = preload("res://Scenes/UI/CreditsMenu.tscn") as PackedScene
@onready var sound_manager = $"../SoundManager"
@onready var settings_menu = $"../SettingsMenu"

@export var main : Main

func _ready():
	start_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
	
func on_start_pressed() -> void:
	main.open_gameplay(0)
	queue_free()
	#

func on_settings_pressed() -> void:
	#var scene_instance = settings_menu.instantiate()
	#add_child(scene_instance)
	settings_menu.z_index = 101
	sound_manager.z_index = 100

func on_credits_pressed() -> void:
	var scene_instance = credits_menu.instantiate()
	add_child(scene_instance)

func on_exit_pressed() -> void:
	get_tree().quit()
