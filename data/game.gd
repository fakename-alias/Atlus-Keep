extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()
@onready var donut: MeshInstance3D = $Donut
@onready var turnManager = $TurnManager

@onready var unitRoot = $Units
@onready var playerRoot = $Units/UnitPlayers
@onready var enemyRoot = $Units/UnitEnemies

var tileArray = []
var playerUnits : Array[Node] = []
var enemyUnits : Array[Node] = []

func _ready():
	donut.position = $LevelNotgrid/Tiles/Tile1.position
	
	playerUnits = playerRoot.get_children()
	enemyUnits = enemyRoot.get_children()
	
	#region == Unit Initialization Test ==
	for unit in playerUnits:
		var random = randi_range(0, 200)
		unit.spawn(level)
		
		while levelTiles[random].has_occupant():
			random = randi_range(0,200)
			print("Tile has occupant")
			
		var cell = levelTiles[random].get_cell_pos()
		unit.move_to_cell(cell)
		levelTiles[random].set_occupant(unit)
		
	#endregion


#region == DEBUG ==
func _input(event):
	if event.is_action_pressed("select"):
		
		var random = randi_range(0,200)
		
		## Move placeholder donut to random cell to demonstrate grid movement
		if levelTiles[random].walkable:
			donut.position = levelTiles[random].position
			
			var currCell : Vector3i = levelTiles[random].get_cell_pos()
			
			print("Donut moved to cell position: " + str(currCell) + ", or " + str(level.get_cell(currCell).name))
			
			level.get_cell(currCell)
		else:
			print("unwalkable at index: " + str(random))
#endregion == DEBUG ==
