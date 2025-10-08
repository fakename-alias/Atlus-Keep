extends Control

@onready var game= $"../.."
@onready var moveButton = $"Move"
@onready var infoBar = $UnitInfo

func _ready() -> void:
	## Connecting button signals to game.gd
	if not moveButton.pressed.is_connected(game._on_move_pressed):
		moveButton.pressed.connect(game._on_move_pressed)
		print("Move button connected")
	
	infoBar.text = "Game Start - Placeholder Text"
