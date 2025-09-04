extends Node2D

@onready var settings_overlay = $CanvasLayer

func _on_exit_pressed() -> void:
	get_tree().quit();
	


func _on_settings_pressed() -> void:
	settings_overlay.visible = true
