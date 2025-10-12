extends Control
class_name BattleUI

@onready var game= $"../.."
@onready var moveButton = $"Move"
@onready var attackButton = $Attack
@onready var infoBar = $UnitInfo

func _ready() -> void:
	## Connecting button signals to game.gd
	if not moveButton.pressed.is_connected(game._on_move_pressed):
		moveButton.pressed.connect(game._on_move_pressed)
		print("HUD >> Move button connected")
	
	if not attackButton.pressed.is_connected(game._on_attack_pressed):
		attackButton.pressed.connect(game._on_attack_pressed)
		print("HUD >> Attack button connected")
	
	infoBar.text = "Game Start - Placeholder Text"
