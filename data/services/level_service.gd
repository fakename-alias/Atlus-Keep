extends Node3D
class_name LevelNotGrid

## basic level environmental data
@export var tilesRootPath : NodePath = "Tiles"
@export var cellSize : float = 1.25
@export var yLevel : float = 0.0

@onready var game : Node3D = $".."

var tileAt: = {}
var boundsMin: Vector3i
var boundsMax: Vector3i

func _ready() -> void:
	
	## Verify Tile root
	var tilesRoot = get_node_or_null(tilesRootPath)
	if tilesRoot == null:
		push_error("No tiles root...")
		return
	
	tileAt.clear()		## Clear all tiles in level dictionary before readding
	var first := true
	for c in tilesRoot.get_children():
		if not (c is Node3D):
			continue
		var cell = world_to_cell((c as Node3D).global_position)
		tileAt[cell] = c
		
		if first:
			boundsMin = cell
			boundsMax = cell
			first = false
		else:
			boundsMin = Vector3i(
					min(boundsMin.x, cell.x),
					0,
					min(boundsMin.z, cell.z))
			boundsMax = Vector3i(
					min(boundsMax.x, cell.x),
					0,
					min(boundsMax.z, cell.z))
	print(str(tileAt.size()))

# Return cell from world position
func world_to_cell(worldPos: Vector3) -> Vector3i:
	var x := int(round(worldPos.x / cellSize))
	var z := int(round(worldPos.z / cellSize))
	return Vector3i(x, 0, z)

# Return world position from cell
func cell_to_world(cell: Vector3i) -> Vector3:
	return Vector3(cell.x * cellSize, yLevel, cell.z * cellSize)
	

# Return if tile at cell position c
func has_cell(c: Vector3i) -> bool:
	return tileAt.has(c)

func get_cell(c: Vector3i) -> Tile:
	if not has_cell(c):
		return null
	
	var tile = tileAt[c]
	var meta = tile as Tile
	if meta:		
		return meta
	else:
		print("No tile at: " + str(c))
	return null;

# Check if tile is walkable at cell pos c
func tile_walkable(c : Vector3i) -> bool:
	if not has_cell(c):
		return false
	var tile = tileAt[c]
	var meta = tile as Tile
	if meta:
		return meta.walkable
	return true

func yeaaa():	#debug function, disregard
	print("yeaaa")

# Return tile cose at cell pos c
func tile_cost(c: Vector3i):
	var tile = tileAt.get(c, null)
	if tile == null:
		return 9999
	var meta = tile as Tile
	if meta:
		return meta.terrain_cost
