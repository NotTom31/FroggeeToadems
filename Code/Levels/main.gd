class_name Main
extends Node2D

@onready var game_level = preload("res://Scenes/Levels/Test/Main-Scene-Tom.tscn") as PackedScene
@onready var main_menu = preload("res://Scenes/UI/MainMenu.tscn") as PackedScene
@export var sound_manager : SoundManager
@export var background : Background

var level_num : int

func open_gameplay(level):
	level_num = level
	var game = game_level.instantiate()
	var game_root = $"."
	game_root.add_child(game)
	#var num_children = get_child_count()
	#move_child(game, num_children - 1)

func open_menu():
	var menu = main_menu.instantiate()
	add_child(menu)

func play_sound(name : String):
	sound_manager.play_sfx(name)

func play_shop_music(is_playing : bool):
	sound_manager.shop_music(is_playing)

func shopkeep_visible(is_visible : bool):
	background.shopkeep_visible(is_visible)

func shopkeep_talk(is_talk : bool):
	pass

func sell_frogs(froglist : String):
	pass