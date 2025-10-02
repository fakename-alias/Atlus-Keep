extends Node2D


func _on_exit_pressed() -> void:
	print("key pressed")
	get_tree().quit()


func _on_settings_pressed() -> void:
	print("Key_pressed")
