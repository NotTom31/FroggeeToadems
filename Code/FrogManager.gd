extends Node

# The currently selected frog
var selected_frog: RigidBody2D = null

# Method to select a frog
func select_frog(frog: RigidBody2D) -> void:
	if selected_frog and selected_frog != frog:
		# Deselect the previously selected frog
		selected_frog.deselect()
		
	# Select the new frog
	selected_frog = frog
	frog.selected = true

# Method to deselect the current frog
func deselect_frog() -> void:
	if selected_frog:
		selected_frog.deselect()
		selected_frog = null
