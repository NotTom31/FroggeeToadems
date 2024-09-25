extends CharacterBody2D

# Adjust the path to reflect your actual node structure
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Correct this if the path is different

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play the "Merchant_Idle" animation when the scene is ready
	animated_sprite_2d.play("Merchant_Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass  # Use '_delta' to avoid warnings for unused parameters
