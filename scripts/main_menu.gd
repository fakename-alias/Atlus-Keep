extends Node2D


func _on_exit_pressed() -> void:
	print("key pressed")
	get_tree().quit()


func _on_settings_pressed() -> void:
	print("Key_pressed")


func _on_start_pressed() -> void:
	print("Play button pressed")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	pass # Replace with function body.
