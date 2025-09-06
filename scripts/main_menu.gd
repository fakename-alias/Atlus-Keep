extends Node2D

<<<<<<< HEAD
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
=======
@onready var settings_overlay = $CanvasLayer

func _on_exit_pressed() -> void:
	get_tree().quit();
	


func _on_settings_pressed() -> void:
	settings_overlay.visible = true
>>>>>>> 17348ef00712dd7191ea451515ce7b989127f477
