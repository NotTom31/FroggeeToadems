class_name FrogSpawner
extends Node

@export var frog_scenes : Array[PackedScene]
@export var lillypad_parent : Node2D
@export var starting_frog_count = []
var frog_parents : Array[Node2D]
signal spawned_frog(frog : BasicFrog)

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
		for i in starting_frog_count:
			spawn_frog_random_loc(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Spawns a frog of the chosen type in a random location in the Spawn Area
func spawn_frog_random_loc(type : MagicManager.FrogType) -> void:
	var r : Rect2 = $SpawnArea/CollisionShape2D.shape.get_rect()
	var vec = Vector2(randf_range(r.position.x, r.position.x + r.size.x), 
		randf_range(r.position.y, r.position.y + r.size.y))
	spawn_frog(type, vec + self.global_position)

# Spawns a frog of the chosen type
func spawn_frog(type : MagicManager.FrogType, loc : Vector2) -> void:
	# Instantiate the frog scene
	var frog_inst = frog_scenes[type].instantiate()
	frog_parents[type].add_child(frog_inst)
	frog_inst.global_position = loc
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
