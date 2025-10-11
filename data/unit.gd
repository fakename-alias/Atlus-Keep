extends Node3D

@onready var teamRoot : Node3D = $".."
@onready var unitRoot : Node3D = $"../.."
@onready var gameRoot : Node3D = $"../../.."

var level : LevelNotGrid
var cell: Tile
var isMoving : bool = false

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

## Initializion
func spawn(level: LevelNotGrid):
	self.level = level
	var pos = level.world_to_cell(position)

func use_movepoints(cost: int):
	movePoints -= cost
	print("Used, ", cost, " AP!")

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

## Animated movement
func animate_path(path: Array[Vector3i], level: LevelNotGrid, stepTime := 0.15) -> void:
	if path.size() <= 1:
		return
	isMoving = true
	
	var curTile: Tile = cell
	
	# Free the starting tile once movement begins
	if curTile:
		curTile.set_occupant(null)
	
	for i in range(1, path.size()):
		var nextCell: Vector3i = path[i]
		var nextTile: Tile = level.get_cell(nextCell)
		if nextTile == null:
			continue
		
		# Tweening??
		var tween := get_tree().create_tween()
		
		tween.tween_property(self, "position", nextTile.position, stepTime)
		await tween.finished
		
		## Snap logic & occupancy at each step
		set_cell(nextTile)
		nextTile.set_occupant(self)
		if curTile:						## At every step before the last, clear the las tile's occupancy
			curTile.set_occupant(null)
		curTile = nextTile
	
	isMoving = false
