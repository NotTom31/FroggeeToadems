class_name Main
extends Node2D

@onready var game_level = preload("res://Scenes/Levels/Test/Main-Scene-Tom.tscn") as PackedScene
@onready var level_select = preload("res://Scenes/UI/level_select.tscn") as PackedScene
@onready var main_menu = preload("res://Scenes/UI/canvas_menu.tscn").instantiate()
@export var sound_manager : SoundManager
@export var background : Background
@export var menu_manager : MenuManager


var wand1 = load("res://Assets/Art/Wand/wand-frame-1-scaled.png")
var wand2 = load("res://Assets/Art/Wand/wand-frame-2-scaled.png")
var wand3 = load("res://Assets/Art/Wand/wand-frame-3-scaled.png")

var level_num : int
var frog_spawner : FrogSpawner
var current_game

# cursor tracking vars for particles
var mouse_velocity = Vector2()  # To track mouse movement velocity
var max_velocity = 900  # Cap how fast we can throw the frogs
var mouse_position

var magic_timer = 0

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
	#for MAIN menu
	if current_game:
		current_game.queue_free()  # Remove the current level
	await get_tree().create_timer(0.1).timeout
	var menu = main_menu
	var game_root = $"."
	game_root.add_child(menu)
	shopkeep_visible(false)
	get_tree().reload_current_scene()
	# WIP: for whatever reason, the menu that loads doesn't really work, its just the ui elements with no functionality. Must figure out way to make it actually the main menu.

func play_sound(name : String):
	sound_manager.play_sfx(name)

func play_shop_music(is_playing : bool):
	sound_manager.shop_music(is_playing)

func shopkeep_visible(is_visible : bool):
	background.shopkeep_visible(is_visible)

func shopkeep_talk(is_talk : bool):
	background.shopkeep_talk(is_talk)

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

func set_random_magic_timer():
	magic_timer = randf_range(1.5, 3)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("magic_equip"):
		follow_mouse(delta, $GPUParticles2D.position)
		$GPUParticles2D.emitting = true
		
	elif Input.is_action_pressed("magic_equip"):
		follow_mouse(delta, $GPUParticles2D.position)
		magic_timer -= delta
		if magic_timer <= 0:
			#play sound effect
			play_sound("magic_equip")
			set_random_magic_timer()
	else:
		$GPUParticles2D.emitting = false
	#play sound effect when wand equipped


func follow_mouse(delta: float, offset: Vector2) -> void:
	# Calculate the velocity of the mouse
	offset -= $GPUParticles2D.position
	mouse_position = get_global_mouse_position()
	mouse_velocity = (mouse_position - global_position + offset) / delta  # Calculate velocity
	$GPUParticles2D.position = mouse_position + offset
