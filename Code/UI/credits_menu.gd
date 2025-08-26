extends Control

@onready var back_button: Button = $BackButton as Button

func _ready() -> void:
	back_button.button_down.connect(on_back_pressed)

func on_back_pressed():
	queue_free()
	

#from menu manager group call
func close_credits():
	queue_free()
	
