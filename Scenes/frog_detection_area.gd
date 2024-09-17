extends Area2D

# List to store currently overlapping bodies
var overlapping_bodies : Array[PhysicsBody2D] = []

# Called when the node enters the scene tree for the first time
func _ready():
	# Connect the signals for entering and exiting the area
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))

# Called when a body enters the Area2D
func _on_body_entered(body: PhysicsBody2D):
	# Add the body to the list of overlapping bodies
	if not overlapping_bodies.has(body):
		overlapping_bodies.append(body)
		print(body.name + " entered the area")

# Called when a body exits the Area2D
func _on_body_exited(body: PhysicsBody2D):
	# Remove the body from the list of overlapping bodies
	if overlapping_bodies.has(body):
		overlapping_bodies.erase(body)
		print(body.name + " exited the area")

# Get the list of overlapping bodies
func get_overlapping_bodies_list() -> Array[PhysicsBody2D]:
	return overlapping_bodies
