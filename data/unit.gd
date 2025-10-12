extends Interactable
class_name PlayableUnit

@onready var teamRoot : Node = $".."
@onready var unitRoot : Node = $"../.."

var playerUnit : bool
var team
@export var movePoints = 5
@export var attackRange = 2

func _ready():
	if teamRoot.name == "UnitPlayers":
		playerUnit = true
		print("Player unit initialized")
	elif teamRoot.name == "UnitEnemies":
		print("Enemy unit initialized")
		playerUnit = false
	else:
		print("Error - Unit not in team initialized")
	pass

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

func use_movepoints(cost: int):
	movePoints -= cost
	print("Used, ", cost, " AP!")
