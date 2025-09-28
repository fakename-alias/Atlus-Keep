extends TileMapLayer

@export var FLOOR_MAX_WIDTH = 18
@export var FLOOR_MAX_HEIGHT = 10

func _ready() -> void:
	CreateFloor()

func CreateFloor() -> void: # add random generation later
	for i in FLOOR_MAX_WIDTH:
		for j in FLOOR_MAX_HEIGHT:
			super.set_cell(Vector2i(i, j), 1,Vector2i(1, 0))
			
