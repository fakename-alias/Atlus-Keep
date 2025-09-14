extends Node

@export var readiness = 0 # Always starts at 0 at start of combat, hidden stat only used for turn calculation
@export var readiness_gain = randi() % 10 + 5 # Temporary value for testing purposes

var turn_done = true

var is_playable = bool(randi() % 2) # Temporary value for testing purposes
var dex = randi() % 20 + 1 # Temporary value for testing purposes

# Execute a turn (gets called by turn_order.gd)
func get_turn() -> void:
	turn_done = false
	# Everything that happens during the entity's turn goes below this comment
	print(name + " got a turn! Press SPACE to finish turn.") # Temporary end turn mechanism for testing purposes
	
# Temporary end turn mechanism for testing purposes
func _input(event: InputEvent) -> void:
	if ((event.as_text() == "Space") and event.is_released()):
		turn_done = true
