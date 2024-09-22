class_name LevelManager extends Node2D

@export var frog_slots : Array[FrogSlot] = []
@export var dialogue : ShopScreen
@export var canvas_shop : CanvasShop
@export var frog_requests_1 : Array[MagicManager.FrogType]
@export var frog_requests_2 : Array[MagicManager.FrogType]
@export var frog_requests_3 : Array[MagicManager.FrogType]
@export var frog_requests_4 : Array[MagicManager.FrogType]
@export var frog_requests_5 : Array[MagicManager.FrogType]
@export var frog_requests_6 : Array[MagicManager.FrogType]
@export var frog_requests_7 : Array[MagicManager.FrogType]
@export var frog_requests_8 : Array[MagicManager.FrogType]

#@onready var win_screen = preload("res://Scenes/win_screen.tscn") as PackedScene

func _ready() -> void:
	check_frog_total()
	$WinScreen.visible = false
	$GameOver.visible = false

func array_to_dictionary(a : Array[MagicManager.FrogType]) -> Dictionary:
	var dict = {}
	for f in a:
		if dict.has(f):
			dict[f] = dict[f] + 1
		else :
			dict[f] = 1
	return dict


var state : ClickState = ClickState.DEFAULT
enum ClickState { DEFAULT, WAND }

var current_level_num : int = -1  # Initialize with an invalid level number

func open_lvl(num : int):
	current_level_num = num  # Store the level number
	match num:
		0: open_lvl_1()
		1: open_lvl_2()
		2: open_lvl_3()
		3: open_lvl_4()
		4: open_lvl_5()
		5: open_lvl_6()
		6: open_lvl_7()
		7: open_lvl_8()
		_:
			print("invalid level")

var frog_table = {
	MagicManager.FrogType.BASIC : "Basic Frog", 
	MagicManager.FrogType.TROPICAL : "Tropical Frog", 
	MagicManager.FrogType.SMALL : "Small Frog", 
	MagicManager.FrogType.FAT : "Large Frog", 
	MagicManager.FrogType.MUD : "Mud Frog", 
}

func check_for_win() -> bool:
	var is_win : bool = false
	var frog_requests = []

	# Use the stored current_level_num
	match current_level_num:
		0:
			frog_requests = frog_requests_1
		1:
			frog_requests = frog_requests_2
		2:
			frog_requests = frog_requests_3
		3:
			frog_requests = frog_requests_4
		4:
			frog_requests = frog_requests_5
		5:
			frog_requests = frog_requests_6
		6:
			frog_requests = frog_requests_7
		7:
			frog_requests = frog_requests_8
		_:
			# Handle invalid level numbers, if necessary
			return false

	# Check if the current level's frog requests are satisfied
	if dictionary_satisfied(array_to_dictionary(frog_requests), $FrogSpawner.count_existing_frogs_by_type()):
		is_win = true
		$WinScreen.visible = true
	return is_win



#func _process(delta: float) -> void:
#	check_for_game_over()

func check_for_game_over():
	if $FrogSpawner.count_total_frogs() <= 1:
		$GameOver.visible = true

func check_frog_total():
	if get_tree().root.get_child(0) is Main:
		match $FrogSpawner.count_total_frogs():
			0,1,2,3:
				get_tree().root.get_child(0).sound_manager.change_music_layer(0)
			4,5:
				get_tree().root.get_child(0).sound_manager.change_music_layer(1)
				print("wow more frogs")
			6,7:
				get_tree().root.get_child(0).sound_manager.change_music_layer(2)
			8,9:
				get_tree().root.get_child(0).sound_manager.change_music_layer(3)
			10,11,12,13,14:
				get_tree().root.get_child(0).sound_manager.change_music_layer(4)
			_:
				print("too many frogs")


func dictionary_satisfied(requirement : Dictionary, check : Dictionary) -> bool:
	var result := true
	for key in requirement:
		if !check.has(key) or check[key] < requirement[key]:
			result = false
	return result

func open_lvl_1() -> void:
	var requested_frogs = []
	for f in frog_requests_1:
		requested_frogs.append(frog_table[f])
	dialogue.tac_dialogue()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(0, requested_frogs)

func open_lvl_2() -> void:
	var requested_frogs = []
	for f in frog_requests_2:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(1)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(1, requested_frogs)

func open_lvl_3() -> void:
	var requested_frogs = []
	for f in frog_requests_3:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(2)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(2, requested_frogs)
	
func open_lvl_4() -> void:
	var requested_frogs = []
	for f in frog_requests_4:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(3)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(3, requested_frogs)

func open_lvl_5() -> void:
	var requested_frogs = []
	for f in frog_requests_5:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(4)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(4, requested_frogs)

func open_lvl_6() -> void:
	var requested_frogs = []
	for f in frog_requests_6:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(5)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(5, requested_frogs)

func open_lvl_7() -> void:
	var requested_frogs = []
	for f in frog_requests_7:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(6)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(6, requested_frogs)

func open_lvl_8() -> void:
	var requested_frogs = []
	for f in frog_requests_8:
		requested_frogs.append(frog_table[f])
	dialogue.update_customer_by_id(7)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(7, requested_frogs)

func add_frog_slot(slot : FrogSlot) -> void:
	frog_slots.append(slot)
	
func remove_frog_slot(slot : FrogSlot) -> void:
	frog_slots.erase(slot)

func closest_open_frog_slot(pos : Vector2) -> FrogSlot:
	var distance = 150
	var result : FrogSlot = null
	for fs in frog_slots:
		if (not fs.is_open()):
			continue
		var temp_dist = pos.distance_to(fs.global_position)
		if (temp_dist < distance):
			distance = temp_dist
			result = fs
	return result

func _on_frog_deselected(frog: BasicFrog, pos: Vector2) -> void:
	var slot = closest_open_frog_slot(pos)
	
	if slot == null:
		frog.Transitioned.emit("FrogFall")
		return
	
	frog.Transitioned.emit("FrogStacked")
	frog.assign_to_slot(slot)
	frog.snap_to_slot(slot)

func _on_frog_spawner_spawned_frog(frog: BasicFrog) -> void:
	add_frog_slot(frog.get_head_slot())
	frog.frog_deselected.connect(self._on_frog_deselected)
	frog.lvl_manager = self

func set_state(s: ClickState) -> void:
	state = s

func _on_wand_button_pressed() -> void:
	if state == ClickState.WAND:
		state = ClickState.DEFAULT
	else:
		state = ClickState.WAND

func check_for_magic(list : Array[MagicManager.FrogType]) -> void:
	set_state(ClickState.DEFAULT)
	var spell_index = $MagicManager.evaluate_frog_stack(list)
	$MagicManager.cast_spell(spell_index)


func _on_magic_manager_summon(type: MagicManager.FrogType) -> void:
	$FrogSpawner.spawn_frog_random_loc(type)
