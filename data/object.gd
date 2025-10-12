extends Node3D
class_name Interactable

@onready var gameRoot : Node3D = $"../../.."

var level : LevelNotGrid
var cell: Tile
var isMoving : bool = false

## Initializion
func spawn(level: LevelNotGrid):
	self.level = level
	var pos = level.world_to_cell(position)
	
func die():
	cell.set_occupant(null)
	queue_free()
	pass

## Setters and getters for cells to avoid typing issues
func set_cell(cell: Tile):
	self.cell = cell;

func get_cell() -> Tile:
	return cell;

## Non-animated movement
func move_to_cell(c: Vector3i):
	if level.has_cell(c) and level.get_cell(c).get_occupant() == null:
		position = level.get_cell(c).position
		print(name, " moved to cell position: ", str(c))
		
		set_cell(level.get_cell(c))
		print("New cell: ", str(level.get_cell(c)))
	return
