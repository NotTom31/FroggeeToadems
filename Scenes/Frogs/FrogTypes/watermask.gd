extends Sprite2D

var repeat_offset = 100
var y_bob_speed = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func water_mask():
	clip_children = CLIP_CHILDREN_ONLY
	self_modulate = Color(1, 1, 1, 1)

func water_unmask():
	clip_children = CLIP_CHILDREN_DISABLED
	self_modulate = Color(1, 1, 1, 0) # clear 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_in_seconds = Time.get_ticks_msec() / 1000.0
	self.offset.y = 10 - 5 * sin(time_in_seconds * y_bob_speed)
	self.offset.x = 10 * sin(time_in_seconds * y_bob_speed * .5)
