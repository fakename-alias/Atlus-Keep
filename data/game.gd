extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()

@onready var unitRoot : Node = $Units
@onready var camera : Camera3D = $Camera3D
@onready var hud : BattleUI = $Camera3D/Hud
@onready var pathfinder : Node = $Pathfinder

var selectedUnit : Node3D = null
var reachable: Dictionary = {} # { Vector3i: bool } as {cell_pos:true/false}

var playerUnits : Array[Interactable] = []
var enemyUnits : Array[Interactable] = []
var environmentObjects : Array[Interactable] = []

enum GameState { IDLE, MOVING, ANIMATING, ATTACKING }
var state: int = GameState.IDLE

func _ready():
	update_hud()
	
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
	
	#playerUnits = unitRoot.get_child(0).get_children()
	#enemyUnits = unitRoot.get_child(1).get_children()
	_gather_children(unitRoot.get_child(0), playerUnits)
	_gather_children(unitRoot.get_child(1), enemyUnits)
	_gather_children(unitRoot.get_child(2), environmentObjects)
	
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
	
	for object in environmentObjects:
		var random = randi_range(0, 200)
		object.spawn(level)
		
		while levelTiles[random].has_occupant():
			random = randi_range(0,200)
			print("Tile has occupant")
			
		var cell = levelTiles[random].get_cell_pos()
		object.move_to_cell(cell)
		object.set_cell(levelTiles[random])
		levelTiles[random].set_occupant(object)
		print("Object ", object.name, " assigned to: ", levelTiles[random].name)
		
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

func _on_attack_pressed() -> void:
	if selectedUnit == null: # Move should do nothign if no unit
		return
		
	# Get cells within range
	reachable = pathfinder.get_units_reachable(level, selectedUnit)
	
	#Highlight all cells in reange
	for c in reachable.keys():
		level.get_cell(c).highlight(2)
	state = GameState.ATTACKING
	print("Attack Button pressed")
	pass

#region == Tile Area3D signals ==#
## All tile click logic
func _on_tile_area_input(camera: Node, event: InputEvent, 
	event_position: Vector3, normal: Vector3, shape_idx: int, tile: Tile) -> void:
	
	if event.is_action_pressed("select"):
		match state:
			## Selecting a unit (only if tile HAS unit)
			GameState.IDLE:
				if selectedUnit != null:
					clear_selection_and_highlights()
				
				if tile.has_occupant() and tile.get_occupant() is PlayableUnit:
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
					print("Tile date - ", tile.name, " - Occupant: ", tile.get_occupant())
			
			## Do nothing while unit is moving
			GameState.ANIMATING:
				pass
			
			## Atk
			GameState.ATTACKING:
				print("Attack queued")
				if selectedUnit == null: ## Should never happen, but just in case
					clear_selection_and_highlights()
				
				if tile.get_occupant() is EnviromentalObject:
					tile.get_occupant().die()
					selectedUnit.use_movepoints(1)
					clear_selection_and_highlights()
	
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

## Updated with animated movement
func _on_move(cellPos: Vector3i) -> void:
	
	if selectedUnit == null : return;
	if state == GameState.ANIMATING: return;
	
	selected_unit_tile().set_occupant(null)
	
	# Build the path
	var path: Array[Vector3i] = pathfinder.find_path(level, selectedUnit, cellPos)
	var cost: int = path.size() - 1
	if path.is_empty():
		print("No path to destination.")
		return
	
	# Clear highlights before moving (optional: keep them until finished)
	for c in reachable.keys():
		level.get_cell(c).highlight(0)
	reachable.clear()
	
	for c in path:
		level.get_cell(c).highlight(4)
	
	state = GameState.ANIMATING
	# Animate along the path (await to block further input)
	await selectedUnit.animate_path(path, level, 0.1)  # adjust speed here
	selectedUnit.use_movepoints(cost)
	
	# End selection and reset HUD/state
	clear_selection_and_highlights()
	update_hud()
	state = GameState.IDLE

## Debug == Updating HUD
func update_hud() -> void:
	if selectedUnit != null:
		hud.infoBar.text = ("Selected Unit - " + str(selectedUnit.name) + " // Remaining Action Points: " + str(selectedUnit.movePoints))
		hud.attackButton.disabled = false
		
		if selectedUnit.movePoints <= 0:
			hud.moveButton.disabled = true
			hud.attackButton.disabled = true
		else:
			hud.moveButton.disabled = false
			hud.moveButton.disabled = false
	else:
		hud.infoBar.text = "No Selected Unit"
		hud.moveButton.disabled = true
		hud.attackButton.disabled = true
	
func select_unit(unit: Interactable) -> void:
	selectedUnit = unit

func _gather_children(root: Node, array: Array):
	for child in root.get_children():
		array.append(child)
	pass
