extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()

@onready var unitRoot = $Units
@onready var camera = $Camera3D
@onready var hud = $Camera3D/Hud
@onready var pathfinder = $Pathfinder

var selectedUnit : Node3D = null
var reachable: Dictionary = {} # { Vector3i: bool } as {cell_pos:true/false}

var playerUnits : Array[Node] = []
var enemyUnits : Array[Node] = []

enum GameState { IDLE, MOVING, ATTACKING }
var state: int = GameState.IDLE

func _ready():
	
	#region == Tile signals ==
	for t in levelTiles:
		var tile := t as Tile
		if tile == null:
			continue
		var a := tile.area
		
		## Connect the tile signals to this controller
		if not a.input_event.is_connected(_on_tile_area_input):
			a.input_event.connect(_on_tile_area_input.bind(tile))
		if not a.mouse_entered.is_connected(_on_tile_mouse_enter.bind(tile)):
			a.mouse_entered.connect(_on_tile_mouse_enter.bind(tile))
		if not a.mouse_exited.is_connected(_on_tile_mouse_exit.bind(tile)):
			a.mouse_exited.connect(_on_tile_mouse_exit.bind(tile))
	#endregion
	
	playerUnits = unitRoot.get_child(0).get_children()
	enemyUnits = unitRoot.get_child(1).get_children()
	
	#region == Unit Initialization Test ==
	for unit in playerUnits:
		var random = randi_range(0, 2)
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

# == Hud buttons == #
func _on_move_pressed() -> void:	
	if selectedUnit == null: # Move should do nothign if no unit
		return
		
	# Get cells within range
	reachable = pathfinder.get_reachable(level, selectedUnit)
	
	#Highlight all cells in reange
	for c in reachable.keys():
		level.get_cell(c).highlight(2)
	state = GameState.MOVING
	print("Move Button press detected.")

#region == Tile Area3D signals ==#

func _on_tile_area_input(camera: Node, event: InputEvent, 
	event_position: Vector3, normal: Vector3, shape_idx: int, tile: Tile) -> void:
	
	if event.is_action_pressed("select"):
		match state:
			## Selecting a unit (only if tile HAS unit)
			GameState.IDLE:
				if selectedUnit != null:
					clear_selection_and_highlights()
				
				if tile.has_occupant():
					select_unit(tile.get_occupant())
					tile.highlight(2)
					update_hud()
				else:
					pass
			## Only allow movement to reachable cells
			GameState.MOVING:
				var c := tile.get_cell_pos()
				if reachable.has(c):
					_on_move(c)
					state = GameState.IDLE
				else:
					print("Non-reachable tile selected")
	
	elif event.is_action_pressed("deselect"):
		clear_selection_and_highlights()

func _on_tile_mouse_enter(tile: Tile) -> void:
	if state == GameState.IDLE:
		if tile != selected_unit_tile():
			tile.highlight(1) #highlight hovered

func _on_tile_mouse_exit(tile: Tile) -> void:
	if state == GameState.IDLE:
		if tile != selected_unit_tile(): # Tile hover only when selecting units
			tile.highlight(0) #clear
#endregion

#region == Helper Functions ==
func selected_unit_tile() -> Tile:
	if selectedUnit == null:
		return null
	return selectedUnit.get_cell()

func clear_selection_and_highlights():
	for t in levelTiles:
		t.highlight(0)
	selectedUnit = null
	state = GameState.IDLE
	reachable.clear()
	update_hud()
	print("Selection cleared!")
#endregion

func _on_move(cellPos: Vector3i) -> void:
	
	if selectedUnit == null : return; 
	
	selectedUnit.move_to_cell(cellPos)
	for c in reachable.keys():
		level.get_cell(c).highlight(0)
	level.get_cell(cellPos).set_occupant(selectedUnit)
	selectedUnit = null
	reachable.clear()
	update_hud()

func update_hud() -> void:
	if selectedUnit != null:
		hud.infoBar.text = ("Selected Unit - " + str(selectedUnit.name))
	else:
		hud.infoBar.text = "No Selected Unit"
	
func select_unit(unit: Node3D) -> void:
	selectedUnit = unit
