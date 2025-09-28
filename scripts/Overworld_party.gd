extends Area2D

var inputs = {"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN}

func _ready() -> void: #later will search for the entrance tile and spawn on that, for now just spawn at top left
	position = position.snapped(Vector2.ONE * 64)
	position += Vector2.ONE * 64/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			Move(dir)	

@onready var ray = $RayCast2D

func Move(dir):
	ray.target_position = inputs[dir] * 64
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += inputs[dir] * 64
