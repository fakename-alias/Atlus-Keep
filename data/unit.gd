extends Node3D

@onready var teamRoot : Node3D = $".."
@onready var unitRoot : Node3D = $"../.."
@onready var gameRoot : Node3D = $"../../.."

var level : LevelNotGrid
var cell: Tile

var team
@export var movePoints = 5

func _ready():
	if teamRoot.name == "UnitPlayers":
		print("Player unit initialized")
	elif teamRoot.name == "UnitEnemies":
		print("Enemy unit initialized")
	else:
		print("Error - Unit not in team initialized")
	pass

func spawn(level: LevelNotGrid):
	self.level = level
	var pos = level.world_to_cell(position)

func set_cell(cell: Tile):
	self.cell = cell;

func get_cell() -> Tile:
	return cell;

func move_to_cell(c: Vector3i):
	if level.has_cell(c) and level.get_cell(c).get_occupant() == null:
		position = level.get_cell(c).position
		print(name, " moved to cell position: ", str(c))
		
		set_cell(level.get_cell(c))
		print("New cell: ", str(level.get_cell(c)))
	return
