class_name MainMenu
extends Control


@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/CreditsButton as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
@onready var game_level = preload("res://Scenes/hello_world.tscn") as PackedScene


func _ready():
	start_button.button_down.connect(on_start_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game_level)

func on_credits_pressed() -> void:
	pass

func on_exit_pressed() -> void:
	get_tree().quit()
