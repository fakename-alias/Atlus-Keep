extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()
@onready var turnManager = $TurnManager

@onready var unitRoot = $Units
@onready var camera = $Camera3D
@onready var hud = $Camera3D/Hud

@onready var pathfinder = $Pathfinder

var selectedUnit : Node3D = null
var reachable: Dictionary = {}

var tileArray = []
var playerUnits : Array[Node] = []
var enemyUnits : Array[Node] = []

func _ready():	
	playerUnits = unitRoot.get_child(0).get_children()
	enemyUnits = unitRoot.get_child(1).get_children()
	
	#region == Unit Initialization Test ==
	for unit in playerUnits:
		var random = randi_range(0, 200)
		unit.spawn(level)
		
		while levelTiles[random].has_occupant():
			random = randi_range(0,200)
			print("Tile has occupant")
			
		var cell = levelTiles[random].get_cell_pos()
		unit.move_to_cell(cell)
		unit.set_cell(levelTiles[random])
		levelTiles[random].set_occupant(unit)
	
	for unit in enemyUnits:
		var random = randi_range(0, 200)
		unit.spawn(level)
		
		while levelTiles[random].has_occupant():
			random = randi_range(0,200)
			print("Tile has occupant")
			
		var cell = levelTiles[random].get_cell_pos()
		unit.move_to_cell(cell)
		unit.set_cell(levelTiles[random])
		levelTiles[random].set_occupant(unit)
		
	#endregion


#region == DEBUG ==
func _input(event):
	if event.is_action_pressed("deselect"):
		selectedUnit = null
		print("Unit deselected")
		update_hud()
		pass
#endregion == DEBUG ==

func _on_move_pressed() -> void:
	if selectedUnit != null:
		reachable = pathfinder.get_reachable(level, selectedUnit)
		for c in reachable.keys():
			level.get_cell(c).highlight(2)
	print("Move Button press detected.")

func _on_move(tile) -> void:
	selectedUnit.move_to_cell(tile)

func update_hud() -> void:
	if selectedUnit != null:
		hud.infoBar.text = ("Selected Unit - " + str(selectedUnit.name))
	else:
		hud.infoBar.text = "No Selected Unit"
	
func select_unit(unit: Node3D) -> void:
	selectedUnit = unit
