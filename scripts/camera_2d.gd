extends Camera2D

var inputs = {"d": Vector2.RIGHT,
	"a": Vector2.LEFT,
	"w": Vector2.UP,
	"s": Vector2.DOWN}

func _ready() -> void:
	pass
	
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			MoveCamera(dir)	

func MoveCamera(dir):
	position += inputs[dir] * 64
