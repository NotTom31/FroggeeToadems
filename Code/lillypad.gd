class_name Lillypad
extends Area2D

@export var lvl_manager : LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_held_frog_types() -> Array[MagicManager.FrogType]:
	if $FrogSlot.inhabitant == null:
		return []
	else:
		return $FrogSlot.inhabitant.get_held_frog_types()

func fountain() -> void:
	if $FrogSlot.inhabitant != null:
		# NOTE: 90% of this is just for the sound effect, only mechanical part is the line: $FrogSlot.inhabitant.fountain()
		# play fountain sounds
		var snap_count =  float(self.count_frogs_in_stack())
		var snap_time = .4+.025*snap_count
		var snap_step = snap_time/snap_count
		var snap_pitch: float
		var snap_paths = ["res://Assets/Audio/SFX/post-jam addition/frogsnap1.wav","res://Assets/Audio/SFX/post-jam addition/frogsnap2.wav","res://Assets/Audio/SFX/post-jam addition/frogsnap3.wav"]
		
		# the only mechanical line :
		$FrogSlot.inhabitant.fountain()
		
		for snap in range(snap_count):
			$FountainSnapPlayer1.set_stream(load(snap_paths[randi_range(0,2)])) 
			snap_pitch = 0.9-snap_count*.05+.25*snap/sqrt(snap_count)
			$FountainSnapPlayer1.set_pitch_scale(snap_pitch)
			$FountainSnapPlayer1.volume_db = 10 + randf_range(-3, 1)
			#choose player from round robin
			$FountainSnapPlayer1.play()
			await get_tree().create_timer(snap_step*randf_range(0.92,1.1)).timeout

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if lvl_manager.state != LevelManager.ClickState.DEFAULT:
			check_for_magic()
		fountain()

func check_for_magic() -> void:
	lvl_manager.check_for_magic(get_held_frog_types())

func count_frogs_in_stack() -> int:
	var count = 0
	var frog : BasicFrog = $FrogSlot.inhabitant
	while frog != null:
		count += 1
		frog = frog.get_frog_on_head()
	return count
