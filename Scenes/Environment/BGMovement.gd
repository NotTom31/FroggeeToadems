extends Node2D

var cloud_speed: float = 50.0 
var boat_bob_amplitude: float = 10.0
var boat_bob_speed: float = 2.0

@onready var clouds_layer: ParallaxLayer = $ParallaxBackground/Clouds
@onready var boat_layer: ParallaxLayer = $ParallaxBackground2/Boat

func _process(delta) -> void:
	clouds_layer.motion_offset.x += cloud_speed * delta
	var time_in_seconds = Time.get_ticks_msec() / 1000.0
	boat_layer.motion_offset.y = boat_bob_amplitude * sin(time_in_seconds * boat_bob_speed)
