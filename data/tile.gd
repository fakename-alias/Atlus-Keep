extends Node
class_name Tile

## Tile data

@export var walkable : bool = true 	## Can the surface be traversed? 
@export var terrain_cost : int = 1 	## How much AP to move over it?

@onready var root: Node3D = $"../.."
@onready var collision

@export var node_north : Tile = null
@export var node_east : Tile = null
@export var node_west : Tile = null
@export var node_south : Tile = null

func _ready() -> void:
	node_east = get_node_east()
	node_north = get_node_north()
	node_south = get_node_south()
	node_west = get_node_west()

func _mouse_entered():
	print(self.name)

#Get cell pos
func get_cell_pos() -> Vector3i:
	return root.world_to_cell(self.position)
	
func get_node_east():
	
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x + 2, 0, cellPos.z))
		print("East tile: " + str(tile))
		return tile
	
	return null
	
func get_node_north():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x, 0, cellPos.z - 2))
		print("North tile: " + str(tile))
		return tile
	
	return null

func get_node_west():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x - 2, 0, cellPos.z))
		print("West tile: " + str(tile))
		return tile
	
	return null

func get_node_south():
	var cellPos = get_cell_pos()
	if root.has_cell(Vector3i(cellPos.x, 0, cellPos.z)):
		var tile = root.get_cell(Vector3i(cellPos.x, 0, cellPos.z + 2))
		print("South tile: " + str(tile))
		return tile
	
	return null
