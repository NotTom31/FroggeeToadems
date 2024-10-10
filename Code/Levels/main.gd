class_name Main
extends Node2D

@onready var game_level = preload("res://Scenes/Levels/Test/Main-Scene-Tom.tscn") as PackedScene
@onready var level_select = preload("res://Scenes/UI/level_select.tscn") as PackedScene
@onready var main_menu = preload("res://Scenes/UI/canvas_menu.tscn") as PackedScene
@export var sound_manager : SoundManager
@export var background : Background

var wand1 = load("res://Assets/Art/Wand/wand-frame-1-scaled.png")
var wand2 = load("res://Assets/Art/Wand/wand-frame-2-scaled.png")
var wand3 = load("res://Assets/Art/Wand/wand-frame-3-scaled.png")

var level_num : int
var frog_spawner : FrogSpawner
var current_game

func open_gameplay(level : int):
	level_num = level
	current_game = game_level.instantiate()
	current_game.name = "LevelManager"
	var game_root = $"."
	game_root.add_child(current_game)
	frog_spawner = current_game.get_node("FrogSpawner")
	shopkeep_visible(true)
	current_game.level_opened.connect(self._on_level_started)
	current_game.open_lvl(level)

func open_level_select():
	var game = level_select.instantiate()
	var game_root = $"."
	game_root.add_child(game)

func open_menu():
	if current_game:
		current_game.queue_free()  # Remove the current level
	await get_tree().create_timer(0.1).timeout
	var menu = main_menu.instantiate()
	var game_root = $"."
	game_root.add_child(menu)
	shopkeep_visible(false)

func play_sound(name : String):
	sound_manager.play_sfx(name)

func play_shop_music(is_playing : bool):
	sound_manager.shop_music(is_playing)

func shopkeep_visible(is_visible : bool):
	background.shopkeep_visible(is_visible)

func open_next_level():
	if current_game:
		current_game.queue_free()  # Remove the current level
	await get_tree().create_timer(0.1).timeout
	open_gameplay(level_num + 1)  # Increment level and open the next one

func restart_level():
	if current_game:
		current_game.queue_free()
	await get_tree().create_timer(0.1).timeout
	open_gameplay(level_num)

func _on_frog_slot_assigned(frog : BasicFrog, slot : FrogSlot):
	var tallest_height = frog_spawner.tallest_tower_count()
	sound_manager.change_music_layer(tallest_height)
	if slot == null:
		return
	if slot.type == FrogSlot.SlotType.LILLYPAD:
		play_sound("lillypad_impact")
	elif slot.type == FrogSlot.SlotType.ROCK:
		play_sound("boing1")
	elif slot.type == FrogSlot.SlotType.FROG:
		play_sound("frog_snap")

func _on_level_started(num : int) -> void:
	sound_manager.play_base_music(true)

func set_wand_cursor():
	Input.set_custom_mouse_cursor(wand1, 0, Vector2(34,34))

func wand_anim():
	Input.set_custom_mouse_cursor(wand1, 0, Vector2(34,34))
	await get_tree().create_timer(0.1).timeout
	Input.set_custom_mouse_cursor(wand2, 0, Vector2(34,34))
	await get_tree().create_timer(0.2).timeout
	Input.set_custom_mouse_cursor(wand3, 0, Vector2(34,34))
	await get_tree().create_timer(0.2).timeout
	Input.set_custom_mouse_cursor(wand1, 0, Vector2(34,34))
	reset_cursor()

func reset_cursor():
	Input.set_custom_mouse_cursor(null)
