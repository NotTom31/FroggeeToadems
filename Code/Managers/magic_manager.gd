class_name MagicManager extends Node2D

enum FrogType { BASIC, TROPICAL, SMALL, FAT, MUD }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
	{ FrogType.TROPICAL : 2 }, 	# 0: summon basic
	{ FrogType.SMALL : 2 },		# 1: summon basic
	{ FrogType.FAT : 2 },		# 2: summon basic
	{ FrogType.MUD : 2 },		# 3: summon basic
	{ FrogType.BASIC : 3 },		# 4: summon tropical
	{ FrogType.TROPICAL : 3 },	# 5: summon mud
	{ FrogType.BASIC : 2, FrogType.TROPICAL : 2 }, # 6: summon small
	{ FrogType.SMALL : 3, FrogType.MUD : 3 } # 7: summon fat
]
signal Summon(type: FrogType)
func cast_spell(index : int) -> void:
	match index:
		0, 1, 2, 3:
			Summon.emit(FrogType.BASIC)
		4:
			Summon.emit(FrogType.TROPICAL)
		5:
			Summon.emit(FrogType.MUD)
		6:
			Summon.emit(FrogType.SMALL)
		7:
			Summon.emit(FrogType.FAT)
		_:
			print("tried to cast an invalid spell")
