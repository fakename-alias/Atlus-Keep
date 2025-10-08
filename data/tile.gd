extends MeshInstance3D
class_name Tile

## Tile data

@export var walkable : bool = true 	## Can the surface be traversed? 
@export var terrain_cost : int = 1 	## How much AP to move over it?

@onready var root: Node3D = $"../.." ## Connects to level service
@onready var game: Node3D = $"../../.." ## Connects to game.gd
@onready var area: Area3D = $Area3D  ## Connects to collision related stuff

## Establishing adjacent nodes for easier node traversal
@export var node_north : Tile = null
@export var node_east : Tile = null
@export var node_west : Tile = null
@export var node_south : Tile = null

var color : StandardMaterial3D
var occupant : Node3D = null
##var selected : bool = false
##var moving: bool = false

##signal tile_selected(tile)
##signal move(tile)

func _ready() -> void:
	node_east = get_node_east()
	node_north = get_node_north()
	node_south = get_node_south()
	node_west = get_node_west()
	
	#region -- Optimize into reusable tile scene for later#
	## Set color of tile
	color = StandardMaterial3D.new()
	color.albedo_color = Color(1, 0, 0)
	set_surface_override_material(0, color)
	
	layers = 0 ## Make tile invisible
	area.input_ray_pickable = true
	#endregion#
	
	## Connect signals
	#if not area.input_event.is_connected(_on_area_3d_input_event):
		#area.input_event.connect(_on_area_3d_input_event)
		##print("connected on " + str(self.name))
	#if not area.mouse_entered.is_connected(_on_area_3d_mouse_entered):
		#area.mouse_entered.connect(_on_area_3d_mouse_entered)
	#if not area.mouse_exited.is_connected( _on_area_3d_mouse_exited):
		#area.mouse_exited.connect( _on_area_3d_mouse_exited)
	#
	#if not tile_selected.is_connected(root._on_tile_selected):
		#tile_selected.connect(root._on_tile_selected)
	#if not move.is_connected(game._on_move):
		#move.connect(game._on_move)
	

#func _mouse_entered():
	#print(self.name)

#Get cell pos
func get_cell_pos() -> Vector3i:
	return root.world_to_cell(self.global_position)

#region == To be condensed ==
func get_node_east():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x + 2, 0, cellPos.z))
		#print("East tile: " + str(tile))
		return tile
	
	return null
	
func get_node_north():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x, 0, cellPos.z - 2))
		#print("North tile: " + str(tile))
		return tile
	
	return null

func get_node_west():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x - 2, 0, cellPos.z))
		#print("West tile: " + str(tile))
		return tile
	
	return null

func get_node_south():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x, 0, cellPos.z + 2))
		#print("South tile: " + str(tile))
		return tile
	
	return null
#endregion

## DEBUG ##
func return_all_adjacent_nodes() -> void:
	print("North: ", get_node_north(), " - East: ", get_node_east(), " - South: ", get_node_south(), " - West: ", get_node_west())
	return

## Get occupant
func get_occupant() -> Node3D:
	return occupant
## Check if tile is occupied
func has_occupant() -> bool:
	if occupant == null:
		return false
	else:
		return true
## Setter for occupant
func set_occupant(unit: Node3D):
	occupant = unit

#func clear_move():
	#moving = false
	#selected = false
	#set_occupant(null)

func highlight(mode: int):
	## 1: hover, 2: selected, 3: moveable, 0: clear
	layers = 1
	match mode:
		0:
			#moving = false
			layers = 0
		1:
			color.albedo_color = Color(0,0,1) #blue
		2:
			color.albedo_color = Color(1,0,0) #red
			#moving = true
		3:
			color.albedo_color = Color(0,1,0) #green
		_:
			print("Something went wrong at tile.gd/highlight")


### Signal functions -- Port over to game.gd
#
### Handles tile clicking
#func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#if event.is_action_pressed("select"):
		#
		#print("Moving: ", moving, " -- Selected: ", selected)
		#if !moving:
			##print("Tile clicked: ", self.name, " - Occupant: ", str(get_occupant()))
			##return_all_adjacent_nodes()
			#emit_signal("tile_selected", self)
			#if has_occupant():
				#selected = true
		#
		#elif moving:
			#print("Moving!")
			#emit_signal("move", get_cell_pos())
			#
	#
	#if event.is_action_pressed('deselect'):
		#selected = false
		#layers = 0
#
##region - Handles mouse hovering on tile
#func _on_area_3d_mouse_entered() -> void:
	#print("Hovering over: ", self.name)
	#if !selected and !moving:
		#layers = 1
		#highlight(1)
#
#func _on_area_3d_mouse_exited() -> void:
	#print("Stopped hovering over: ",self.name)
	#if !selected and !moving:
		#layers = 0
##endregion
