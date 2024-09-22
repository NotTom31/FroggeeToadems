extends Control

@onready var back_button: Button = $BackButton as Button
@onready var sound_manager = $"../SoundManager"

func _ready() -> void:
	back_button.button_down.connect(on_back_pressed)

func on_back_pressed():
	z_index = -500
	sound_manager.z_index = 100
