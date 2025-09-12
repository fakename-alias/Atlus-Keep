extends Node

# Always starts at 0 at start of combat
@export var readiness = 0
@export var readiness_gain = randi() % 10 + 5 # Temporary value for testing purposes

var turn_done = true

var is_playable = bool(randi() % 2) # Temporary value for testing purposes
var dex = randi() % 20 + 1 # Temporary value for testing purposes

# Execute a turn (gets called by turn_order.gd)
func get_turn() -> void:
	print(name + " got a turn! Press SPACE to finish turn. (Readiness: " + str(readiness) + ")")
	turn_done = false
	readiness = 0

func _input(event: InputEvent) -> void:
	if ((event.as_text() == "Space") and event.is_released()):
		turn_done = true
