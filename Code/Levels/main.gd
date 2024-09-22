class_name Main
extends Control

@onready var game_level = preload("res://Scenes/Levels/Test/Main-Scene-Tom.tscn") as PackedScene
@onready var main_menu = preload("res://Scenes/UI/MainMenu.tscn") as PackedScene

var level_num : int

func open_gameplay(level):
	level_num = level
	var game = game_level.instantiate()
	add_child(game)

func open_menu():
	var menu = main_menu.instantiate()
	add_child(menu)
