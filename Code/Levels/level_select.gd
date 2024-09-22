extends CanvasLayer

var main : Main

func _enter_tree() -> void:
	if get_tree().root.get_child(0) is Main:
		main = get_tree().root.get_child(0)

func _on_blank_button_pressed() -> void:
	main.open_gameplay(0)
	queue_free()

func _on_blank_button_2_pressed() -> void:
	main.open_gameplay(1)
	queue_free()

func _on_blank_button_3_pressed() -> void:
	main.open_gameplay(2)
	queue_free()

func _on_blank_button_4_pressed() -> void:
	main.open_gameplay(3)
	queue_free()

func _on_blank_button_5_pressed() -> void:
	main.open_gameplay(4)
	queue_free()

func _on_blank_button_6_pressed() -> void:
	main.open_gameplay(5)
	queue_free()

func _on_blank_button_7_pressed() -> void:
	main.open_gameplay(6)
	queue_free()

func _on_blank_button_8_pressed() -> void:
	main.open_gameplay(7)
	queue_free()
