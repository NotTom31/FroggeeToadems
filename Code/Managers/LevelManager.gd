class_name LevelManager extends Node2D

@export var frog_slots : Array[FrogSlot] = []
@export var dialogue : ShopScreen
@export var canvas_shop : CanvasShop
var state : ClickState = ClickState.DEFAULT
enum ClickState { DEFAULT, WAND }

func open_lvl(num : int):
	match num:
		0: open_lvl_1()
		1: open_lvl_2()
		2: open_lvl_3()
		3: open_lvl_4()
		4: open_lvl_5()
		5: open_lvl_6()
		6: open_lvl_7()
		7: open_lvl_8()
		_:print("invalid level")

func open_lvl_1() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.tac_dialogue()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(0, requested_frogs)

func open_lvl_2() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(1)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(1, requested_frogs)

func open_lvl_3() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(2)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(2, requested_frogs)
	
func open_lvl_4() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(3)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(3, requested_frogs)

func open_lvl_5() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(4)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(4, requested_frogs)

func open_lvl_6() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(5)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(5, requested_frogs)

func open_lvl_7() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
	dialogue.update_customer_by_id(6)
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_shop_music(true)
	canvas_shop.animation.play("Transition_In")
	get_tree().paused = true
	dialogue.set_requested_frogs(6, requested_frogs)

func open_lvl_8() -> void:
	var requested_frogs = ["Tropical Frog", "Large Frog"]
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
