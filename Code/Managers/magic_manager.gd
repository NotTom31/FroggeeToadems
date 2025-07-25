class_name MagicManager extends Node2D

enum FrogType { BASIC, TROPICAL, SMALL, FAT, MUD, BRIGHT, DART, ORANGE, PURPLE }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Evaluates a stack of frogs and returns the index of the spell that stack makes.
#If there is no such spell, return -1
func evaluate_frog_stack(stack : Array[FrogType]) -> int:
	var table = {}
	for ft in stack:
		if table.has(ft):
			table[ft] = table[ft] + 1
		else:
			table[ft] = 1
	for spell_index in spell_table.size():
		if table == spell_table[spell_index]:
			return spell_index
	return -1

var spell_table = [
	{ FrogType.TROPICAL : 1 }, 	# 0: summon basic
	{ FrogType.SMALL : 1 },		# 1: summon basic
	{ FrogType.FAT : 1 },		# 2: summon basic
	{ FrogType.MUD : 1 },		# 3: summon basic
	{ FrogType.BASIC : 1 },		# 4: summon basic
	{ FrogType.BRIGHT : 1 },		# 5: summon basic
	{ FrogType.DART : 1 },		# 6: summon basic
	{ FrogType.ORANGE : 1 },		# 7: summon basic
	{ FrogType.PURPLE : 1 },		# 8: summon basic
	{ FrogType.BASIC : 3 },		# 9: summon mud
	{ FrogType.BASIC : 2, FrogType.MUD : 1},	# 10: summon small
	{ FrogType.MUD : 3, FrogType.SMALL : 1 }, # 11: summon fat
	{ FrogType.SMALL : 2, FrogType.BASIC : 2 }, # 12: summon bright
	{ FrogType.BRIGHT : 3, FrogType.FAT : 2 }, 	# 13: summon tropical
	{ FrogType.TROPICAL : 2, FrogType.BRIGHT : 2 }, 	# 14: summon dart temp recipe
	{ FrogType.FAT : 4, FrogType.TROPICAL : 2 }, 	# 15: summon orange
	{ FrogType.MUD : 4, FrogType.TROPICAL : 2 }, 	# 16: summon orange
	{ FrogType.ORANGE : 2, FrogType.DART : 2 }, 	# 17: summon purple
]
signal Summon(type: FrogType)


func cast_spell(index : int) -> void:
	
	match get_spell_output(index):
		"Basic Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.BASIC)
		"Mud Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.MUD)
		"Small Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.SMALL)
		"Large Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.FAT)
		"Bright Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.BRIGHT)
		"Tropical Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.TROPICAL)
		"Dart Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.DART)
		"Orange Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.ORANGE)
		"Purple Frog":
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic")
			Summon.emit(FrogType.PURPLE)
		_:
			print("tried to cast an invalid spell")
			if get_tree().root.get_child(0) is Main:
				get_tree().root.get_child(0).play_sound("magic_fail")

# Assuming FrogType has a to_string() method or some way to convert to text

var frog_type_names = {
	FrogType.TROPICAL: "Tropical Frog",
	FrogType.SMALL: "Small Frog",
	FrogType.FAT: "Fat Frog",
	FrogType.MUD: "Mud Frog",
	FrogType.BASIC: "Basic Frog",
	FrogType.BRIGHT: "Bright Frog",
	FrogType.DART: "Dart Frog",
	FrogType.ORANGE: "Orange Frog",
	FrogType.PURPLE: "Purple Frog"
}

func get_spell_output(index: int) -> String:
	match index:
		0, 1, 2, 3, 4, 5, 6, 7, 8:
			return "Basic Frog"
		9:
			return "Mud Frog"
		10:
			return "Small Frog"
		11:
			return "Large Frog"
		12:
			return "Bright Frog"
		13:
			return "Tropical Frog"
		14:
			return "Dart Frog"
		15,16:
			return "Orange Frog"
		17:
			return "Purple Frog"
		_:
			return "Unknown Spell"

func output_to_index(frog:String):
	# convert output from above func back to index
	match frog:
		"Basic Frog":
			return 0
		"Tropical Frog":
			return 1
		"Small Frog":
			return 2
		"Large Frog":
			return 3
		"Mud Frog":
			return 4
		"Bright Frog":
			return 5
		"Dart Frog":
			return 6
		"Orange Frog":
			return 7
		"Purple Frog":
			return 8
		_:
			print("Frog Name Unknown")
	

func get_recipe_as_string(index: int) -> String:
	if index < 0 or index >= spell_table.size():
		return "Invalid spell index"

	var recipe = spell_table[index]
	var recipe_text = get_spell_output(index) + "\n"
	recipe_text += "Ingredients: "
	for frog_type in recipe:
		var frog_name = frog_type_names.get(frog_type, "Unknown Frog")
		recipe_text += frog_name + ": " + str(recipe[frog_type]) + " "
	return recipe_text

func get_recipe_raw(index: int):
	if index < 0 or index >= spell_table.size():
		return "Invalid spell index"
	
	var recipe = spell_table[index]
	return recipe
	

func get_spellbook_size():
	return spell_table.size()
