class_name MagicManager extends Node2D

enum FrogType { BASIC, TROPICAL, SMALL, FAT }

var spell_table = [
	{ FrogType.BASIC : 3 }, 											#0: summon tropical
	{ FrogType.BASIC : 2, FrogType.TROPICAL : 2 }, 						#1: summon small
	{ FrogType.BASIC : 3, FrogType.TROPICAL : 1, FrogType.SMALL : 3 }	#2: summon fat
]

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
			table[ft] = 0
	for spell_index in spell_table.size:
		if table == spell_table[spell_index]:
			return spell_index
	return -1

func cast_spell(index : int) -> void:
	match index:
		0:
			print("summon tropical")
		1:
			print("summon small")
		_:
			print("tried to cast an invalid spell")
