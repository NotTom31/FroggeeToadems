class_name FrogSpawner
extends Node

@export var frog_scenes : Array[PackedScene]
@export var lillypad_parent : Node2D
@export var starting_frog_count = []
var frog_parents : Array[Node2D]
signal spawned_frog(frog : BasicFrog)

# allow keys to spawn frogs
# comment out before publication!
var dev_tools = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frog_parents = [$BasicFrogs, $TropicalFrogs, $SmallFrogs, $FatFrogs, $MudFrogs, $BrightFrogs, $DartFrogs, $OrangeFrogs, $PurpleFrogs]
	# set starter frogs
	starting_frog_count = []
	if get_tree().root.get_child(0) is Main:
		# at this point in instantiation only main.gd knows level num
		var level = get_tree().root.get_child(0).level_num
		# level manager stores starting frogs per level
		starting_frog_count = get_tree().root.get_child(0).get_node("LevelManager").set_starter_frogs(level)
		for i in range(starting_frog_count.size()):
			spawn_frog_random_loc(starting_frog_count[i-1], true)

# dev_tools
# spawn frogs on keypress
# turn off for release!!! comment out this code! remove inputs from input manager in project settings!@
func _process(delta: float) -> void:
	if dev_tools == true:
		# 1 basic
		if Input.is_action_just_pressed("basic_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.BASIC, false)
		# 2 tropical
		if Input.is_action_just_pressed("tropical_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.TROPICAL, false)
		# 3 small
		if Input.is_action_just_pressed("small_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.SMALL, false)
		# 4 mud
		if Input.is_action_just_pressed("mud_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.MUD, false)
		# 5 fat
		if Input.is_action_just_pressed("fat_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.FAT, false)
		# 6 bright
		if Input.is_action_just_pressed("bright_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.BRIGHT, false)
		# 7 dart
		if Input.is_action_just_pressed("dart_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.DART, false)
		# 8 orange
		if Input.is_action_just_pressed("orange_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.ORANGE, false)
		# 9 purple
		if Input.is_action_just_pressed("purple_spawn"):
			spawn_frog_random_loc(MagicManager.FrogType.PURPLE, false)
		


# Spawns a frog of the chosen type in a random location in the Spawn Area
func spawn_frog_random_loc(type : MagicManager.FrogType, from_init : bool) -> void:
	var r : Rect2 = $SpawnArea/CollisionShape2D.shape.get_rect()
	var vec = Vector2(randf_range(r.position.x, r.position.x + r.size.x), 
		randf_range(r.position.y, r.position.y + r.size.y))
	if from_init == true:
		init_frog(type, vec + self.global_position)
	else:
		spawn_frog(type, vec + self.global_position)
	

# Spawns a frog of the chosen type
func spawn_frog(type : MagicManager.FrogType, loc : Vector2) -> void:
	# Instantiate the frog scene
	var frog_inst = frog_scenes[type].instantiate()
	frog_parents[type].add_child(frog_inst)
	frog_inst.global_position = loc
	# modifying code here for experimental particle sys
	frog_inst.disable_gravity()
	frog_inst.invisible()
	frog_inst.particle_emit()
	# particles only, spawn sound set to play with appropriate delay
	var spawn_time = frog_inst.spawn_speed*randf_range(.95,1.1)
	await get_tree().create_timer(spawn_time).timeout
	# render frog
	frog_inst.enable_gravity()
	frog_inst.visible()
	frog_inst.particle_cease()
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).play_sound("frog_spawn")
	spawned_frog.emit(frog_inst)
	
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).get_node("LevelManager").check_frog_total()

# Spawns a frog of the chosen type at start of level
func init_frog(type : MagicManager.FrogType, loc : Vector2) -> void:
	# Instantiate the frog scene
	var frog_inst = frog_scenes[type].instantiate()
	frog_parents[type].add_child(frog_inst)
	frog_inst.global_position = loc
	# modifying code here for experimental particle sys
	frog_inst.disable_gravity()
	frog_inst.invisible()
	frog_inst.enable_gravity()
	frog_inst.visible()
	#frog_inst.particle_cease()
	spawned_frog.emit(frog_inst)
	
	if get_tree().root.get_child(0) is Main:
		get_tree().root.get_child(0).get_node("LevelManager").check_frog_total()

func count_frogs_of_type(type : MagicManager.FrogType) -> int:
	return frog_parents[type].get_children().size()

func count_existing_frogs_by_type() -> Dictionary:
	var result = {}
	for t in MagicManager.FrogType.values():
		result[t] = count_frogs_of_type(t)
	return result

func count_total_frogs() -> int:
	var dict = count_existing_frogs_by_type()
	var result := 0
	for t in MagicManager.FrogType.values():
		result += dict[t]
	return result

func tallest_tower_count() -> int:
	var max = 0
	var lillypads = lillypad_parent.get_children()
	for t in lillypads:
		var count = t.count_frogs_in_stack()
		if count > max:
			max = count
	return max
