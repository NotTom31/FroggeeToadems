class_name FrogSlot extends Node2D

# this is a spot where a frog can be placed
enum SlotType {
	LILLYPAD,
	FROG,
	ROCK
}

var inhabitant : BasicFrog = null
@export var active : bool
@export var type : SlotType
@export var on_lillypad : bool :
	set(value):
		on_lillypad = value
		if inhabitant != null:
			inhabitant.on_lillypad = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_open() -> bool:
	return inhabitant == null and active
